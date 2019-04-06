function [idxbest, Cbest, sumDbest, Dbest] = fun_kmeans2(X, k, distance,...
                  emptyact, reps, start,Xmins,Xmaxs,CC,online,...
                  display, maxit,useParallel, RNGscheme,...
                  wasnan,hadNaNs,varargin)


%   KMEANS uses a two-phase iterative algorithm to minimize the sum of
%   point-to-centroid distances, summed over all K clusters.  The first phase
%   uses what the literature often describes as "batch" updates, where each
%   iteration consists of reassigning points to their nearest cluster
%   centroid, all at once, followed by recalculation of cluster centroids.
%   This phase occasionally (especially for small data sets) does not converge
%   to solution that is a local minimum, i.e., a partition of the data where
%   moving any single point to a different cluster increases the total sum of
%   distances.  Thus, the batch phase be thought of as providing a fast but
%   potentially only approximate solution as a starting point for the second
%   phase.  The second phase uses what the literature often describes as
%   "on-line" updates, where points are individually reassigned if doing so
%   will reduce the sum of distances, and cluster centroids are recomputed
%   after each reassignment.  Each iteration during this second phase consists
%   of one pass though all the points.  The on-line phase will converge to a
%   local minimum, although there may be other local minima with lower total
%   sum of distances.  The problem of finding the global minimum can only be
%   solved in general by an exhaustive (or clever, or lucky) choice of
%   starting points, but using several replicates with random starting points
%   typically results in a solution that is a global minimum.
%
% References:
%
%   [1] Seber, G.A.F. (1984) Multivariate Observations, Wiley, New York.
%   [2] Spath, H. (1985) Cluster Dissection and Analysis: Theory, FORTRAN
%       Programs, Examples, translated by J. Goldschmidt, Halsted Press,
%       New York.

%   Copyright 1993-2014 The MathWorks, Inc.

if display > 1 % 'final' or 'iter'
    hwb_progress = waitbar(0, '', 'Name', 'Clustering ...');
    irep = 1;    
end

narginchk(5, inf)

% n points in p dimensional space
[n, p] = size(X);

emptyErrCnt = 0;
% Define the function that will perform one iteration of the
% loop inside smartFor
loopbody = @loopBody;

% Initialize nested variables so they will not appear to be functions here
totsumD = 0;
iter = 0;

% Perform KMEANS replicates on separate workers.
ClusterBest = internal.stats.parallel.smartForReduce(...
    reps, loopbody, useParallel, RNGscheme, 'argmin');

% Extract the best solution
idxbest = ClusterBest{5};
Cbest = ClusterBest{6};
sumDbest = ClusterBest{3};
totsumDbest = ClusterBest{1};
if nargout > 3
    Dbest = ClusterBest{7};
end

if display > 1 % 'final' or 'iter'
    % fprintf('%s\n',getString(message('stats:kmeans:FinalSumOfDistances',sprintf('%g',totsumDbest))));
    close(hwb_progress);
end

if hadNaNs
    idxbest = statinsertnan(wasnan, idxbest);
    if nargout > 3
        Dbest = statinsertnan(wasnan, Dbest);
    end
end

    function cellout = loopBody(rep,S)
        
        if isempty(S)
            S = RandStream.getGlobalStream;
        end
        
        if display > 1 % 'iter'
            dispfmt = '%6d\t%6d\t%8d\t%12g\n';
        end
        
        cellout = cell(7,1);  % cellout{1} = total sum of distances
                              % cellout{2} = replicate number
                              % cellout{3} = sum of distance for each cluster
                              % cellout{4} = iteration
                              % cellout{5} = idx;
                              % cellout{6} = Center
                              % cellout{7} = Distance
        
        % Populating total sum of distances to Inf. This is used in the
        % reduce operation if update fails due to empty cluster.
        cellout{1} = Inf;
        cellout{2} = rep;
        
        switch start
            case 'uniform'
                C = Xmins(ones(k,1),:) + rand(S,[k,p]).*(Xmaxs(ones(k,1),:)-Xmins(ones(k,1),:));
                % For 'cosine' and 'correlation', these are uniform inside a subset
                % of the unit hypersphere.  Still need to center them for
                % 'correlation'.  (Re)normalization for 'cosine'/'correlation' is
                % done at each iteration.
                if isequal(distance, 'correlation')
                    C = bsxfun(@minus, C, mean(C,2));
                end
                if isa(X,'single')
                    C = single(C);
                end
            case 'sample'
                C = X(randsample(S,n,k),:);
            case 'cluster'
                Xsubset = X(randsample(S,n,floor(.1*n)),:);
                % Turn display off for the initialization
                optIndex = find(strcmpi('options',varargin));
                if isempty(optIndex)
                    opts = statset('Display','off');
                    varargin = [varargin,'options',opts];
                else
                    varargin{optIndex+1}.Display = 'off';
                end
                [~, C] = kmeans(Xsubset, k, varargin{:}, 'start','sample', 'replicates',1);
            case 'numeric'
                C = CC(:,:,rep);
                if isa(X,'single')
                    C = single(C);
                end
            case {'plus','kmeans++'}
                % Select the first seed by sampling uniformly at random
                index = zeros(k,1);
                [C(1,:), index(1)] = datasample(S,X,1);
                minDist = inf(n,1);
           
                % Select the rest of the seeds by a probabilistic model
                for ii = 2:k                    
                    minDist = min(minDist,distfun(X,C(ii-1,:),distance));
                    denominator = sum(minDist);
                    if denominator==0 || isinf(denominator) || isnan(denominator)
                        C(ii:k,:) = datasample(S,X,k-ii+1,1,'Replace',false);
                        break;
                    end
                    sampleProbability = minDist/denominator;
                    [C(ii,:), index(ii)] = datasample(S,X,1,1,'Replace',false,...
                        'Weights',sampleProbability);        
                end
              end
        if ~isfloat(C)      % X may be logical
            C = double(C);
        end
        
        % Compute the distance from every point to each cluster centroid and the
        % initial assignment of points to clusters
        D = distfun(X, C, distance, 0, rep, reps);
        [d, idx] = min(D, [], 2);
        m = accumarray(idx,1,[k,1]);
        
        try % catch empty cluster errors and move on to next rep
            
            % Begin phase one:  batch reassignments
            converged = batchUpdate();
            
            % Begin phase two:  single reassignments
            if online
                converged = onlineUpdate();
            end
            
            
            if display == 2 % 'final'
                fprintf('%s\n',getString(message('stats:kmeans:IterationsSumOfDistances',rep,iter,sprintf('%g',totsumD) )));
            end
            
            if ~converged
                if reps==1
                    warning(message('stats:kmeans:FailedToConverge', maxit));
                else
                    warning(message('stats:kmeans:FailedToConvergeRep', maxit, rep));
                end
            end
            
            % Calculate cluster-wise sums of distances
            nonempties = find(m>0);
            D(:,nonempties) = distfun(X, C(nonempties,:), distance, iter, rep, reps);
            d = D((idx-1)*n + (1:n)');
            sumD = accumarray(idx,d,[k,1]);
            totsumD = sum(sumD(nonempties));
            
            % Save the best solution so far
             cellout = {totsumD,rep,sumD,iter,idx,C,D}';
           
            % If an empty cluster error occurred in one of multiple replicates, catch
            % it, warn, and move on to next replicate.  Error only when all replicates
            % fail.  Rethrow an other kind of error.
        catch ME
            if reps == 1 || (~isequal(ME.identifier,'stats:kmeans:EmptyCluster')  && ...
                         ~isequal(ME.identifier,'stats:kmeans:EmptyClusterRep'))
                rethrow(ME);
            else
                emptyErrCnt = emptyErrCnt + 1;
                warning(message('stats:kmeans:EmptyClusterInBatchUpdate', rep, iter));
                if emptyErrCnt == reps
                    error(message('stats:kmeans:EmptyClusterAllReps'));
                end
            end
        end % catch
        
        % for updating waitbar
        irep = irep + 1;
        
        %------------------------------------------------------------------
        
        function converged = batchUpdate()
            
            % Every point moved, every cluster will need an update
            moved = 1:n;
            changed = 1:k;
            previdx = zeros(n,1);
            prevtotsumD = Inf;
            
            %
            % Begin phase one:  batch reassignments
            %
            
            iter = 0;
            converged = false;
            while true
                iter = iter + 1;
                
                % Calculate the new cluster centroids and counts, and update the
                % distance from every point to those new cluster centroids
                [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance);
                D(:,changed) = distfun(X, C(changed,:), distance, iter, rep, reps);
                
                % Deal with clusters that have just lost all their members
                empties = changed(m(changed) == 0);
                if ~isempty(empties)
                    if strcmp(emptyact,'error')
                        if reps==1
                            error(message('stats:kmeans:EmptyCluster', iter));
                        else
                            error(message('stats:kmeans:EmptyClusterRep', iter, rep));
                        end
                    end
                    switch emptyact
                        case 'drop'
                            if reps==1
                                warning(message('stats:kmeans:EmptyCluster', iter));
                            else
                                warning(message('stats:kmeans:EmptyClusterRep', iter, rep));
                            end
                            % Remove the empty cluster from any further processing
                            D(:,empties) = NaN;
                            changed = changed(m(changed) > 0);
                        case 'singleton'
                            for i = empties
                                d = D((idx-1)*n + (1:n)'); % use newly updated distances
                                
                                % Find the point furthest away from its current cluster.
                                % Take that point out of its cluster and use it to create
                                % a new singleton cluster to replace the empty one.
                                [~, lonely] = max(d);
                                from = idx(lonely); % taking from this cluster
                                if m(from) < 2
                                    % In the very unusual event that the cluster had only
                                    % one member, pick any other non-singleton point.
                                    from = find(m>1,1,'first');
                                    lonely = find(idx==from,1,'first');
                                end
                                C(i,:) = X(lonely,:);
                                m(i) = 1;
                                idx(lonely) = i;
                                D(:,i) = distfun(X, C(i,:), distance, iter, rep, reps);
                                
                                % Update clusters from which points are taken
                                [C(from,:), m(from)] = gcentroids(X, idx, from, distance);
                                D(:,from) = distfun(X, C(from,:), distance, iter, rep, reps);
                                changed = unique([changed from]);
                            end
                    end
                end
                
                % Compute the total sum of distances for the current configuration.
                totsumD = sum(D((idx-1)*n + (1:n)'));
                % Test for a cycle: if objective is not decreased, back out
                % the last step and move on to the single update phase
                if prevtotsumD <= totsumD
                    idx = previdx;
                    [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance);
                    iter = iter - 1;
                    break;
                end
                if display > 2 % 'iter'
                    % fprintf(dispfmt,iter,1,length(moved),totsumD);
                    waitbar(irep/reps, hwb_progress, sprintf('Replicate %d/%d: Iteration=%d, Sum=%.4d', irep, reps, iter, totsumD));
                end
                if iter >= maxit
                    break;
                end
                
                % Determine closest cluster for each point and reassign points to clusters
                previdx = idx;
                prevtotsumD = totsumD;
                [d, nidx] = min(D, [], 2);
                
                % Determine which points moved
                moved = find(nidx ~= previdx);
                if ~isempty(moved)
                    % Resolve ties in favor of not moving
                    moved = moved(D((previdx(moved)-1)*n + moved) > d(moved));
                end
                if isempty(moved)
                    converged = true;
                    break;
                end
                idx(moved) = nidx(moved);
                
                % Find clusters that gained or lost members
                changed = unique([idx(moved); previdx(moved)])';
                
            end % phase one
            
        end % nested function
        
        %------------------------------------------------------------------
        
        function converged = onlineUpdate()
            
            % Initialize some cluster information prior to phase two
            switch distance
                case 'cityblock'
                    Xmid = zeros([k,p,2]);
                    for i = 1:k
                        if m(i) > 0
                            % Separate out sorted coords for points in i'th cluster,
                            % and save values above and below median, component-wise
                            Xsorted = sort(X(idx==i,:),1);
                            nn = floor(.5*m(i));
                            if mod(m(i),2) == 0
                                Xmid(i,:,1:2) = Xsorted([nn, nn+1],:)';
                            elseif m(i) > 1
                                Xmid(i,:,1:2) = Xsorted([nn, nn+2],:)';
                            else
                                Xmid(i,:,1:2) = Xsorted([1, 1],:)';
                            end
                        end
                    end
                case 'hamming'
                    Xsum = zeros(k,p);
                    for i = 1:k
                        if m(i) > 0
                            % Sum coords for points in i'th cluster, component-wise
                            Xsum(i,:) = sum(X(idx==i,:), 1);
                        end
                    end
            end
            
            %
            % Begin phase two:  single reassignments
            %
            changed = find(m' > 0);
            lastmoved = 0;
            nummoved = 0;
            iter1 = iter;
            converged = false;
            Del = NaN(n,k); % reassignment criterion
            while iter < maxit
                % Calculate distances to each cluster from each point, and the
                % potential change in total sum of errors for adding or removing
                % each point from each cluster.  Clusters that have not changed
                % membership need not be updated.
                %
                % Singleton clusters are a special case for the sum of dists
                % calculation.  Removing their only point is never best, so the
                % reassignment criterion had better guarantee that a singleton
                % point will stay in its own cluster.  Happily, we get
                % Del(i,idx(i)) == 0 automatically for them.
                switch distance
                    case 'sqeuclidean'
                        for i = changed
                            mbrs = (idx == i);
                            sgn = 1 - 2*mbrs; % -1 for members, 1 for nonmembers
                            if m(i) == 1
                                sgn(mbrs) = 0; % prevent divide-by-zero for singleton mbrs
                            end
                          Del(:,i) = (m(i) ./ (m(i) + sgn)) .* sum((bsxfun(@minus, X, C(i,:))).^2, 2);
                        end
                    case 'cityblock'
                        for i = changed
                            if mod(m(i),2) == 0 % this will never catch singleton clusters
                                ldist = bsxfun(@minus, Xmid(i,:,1), X);
                                rdist = bsxfun(@minus, X, Xmid(i,:,2));
                                mbrs = (idx == i);
                                sgn = repmat(1-2*mbrs, 1, p); % -1 for members, 1 for nonmembers
                                Del(:,i) = sum(max(0, max(sgn.*rdist, sgn.*ldist)), 2);
                            else
                                Del(:,i) = sum(abs(bsxfun(@minus, X, C(i,:))), 2);
                            end
                        end
                    case {'cosine','correlation'}
                        % The points are normalized, centroids are not, so normalize them
                        normC = sqrt(sum(C.^2, 2));
                        if any(normC < eps(class(normC))) % small relative to unit-length data points
                            if reps==1
                                error(message('stats:kmeans:ZeroCentroid', iter));
                            else
                                error(message('stats:kmeans:ZeroCentroidRep', iter, rep));
                            end
                            
                        end
                        % This can be done without a loop, but the loop saves memory allocations
                        for i = changed
                            XCi = X * C(i,:)';
                            mbrs = (idx == i);
                            sgn = 1 - 2*mbrs; % -1 for members, 1 for nonmembers
                            Del(:,i) = 1 + sgn .*...
                                (m(i).*normC(i) - sqrt((m(i).*normC(i)).^2 + 2.*sgn.*m(i).*XCi + 1));
                        end
                    case 'hamming'
                        for i = changed
                            if mod(m(i),2) == 0 % this will never catch singleton clusters
                                % coords with an unequal number of 0s and 1s have a
                                % different contribution than coords with an equal
                                % number
                                unequal01 = find(2*Xsum(i,:) ~= m(i));
                                numequal01 = p - length(unequal01);
                                mbrs = (idx == i);
                                Di = abs(bsxfun(@minus,X(:,unequal01), C(i,unequal01)));
                                Del(:,i) = (sum(Di, 2) + mbrs*numequal01) / p;
                            else
                                Del(:,i) = sum(abs(bsxfun(@minus,X,C(i,:))), 2) / p;
                            end
                        end
                end
                
                % Determine best possible move, if any, for each point.  Next we
                % will pick one from those that actually did move.
                previdx = idx;
                prevtotsumD = totsumD;
                [minDel, nidx] = min(Del, [], 2);
                moved = find(previdx ~= nidx);
                moved(m(previdx(moved))==1)=[];
                if ~isempty(moved)
                    % Resolve ties in favor of not moving
                    moved = moved(Del((previdx(moved)-1)*n + moved) > minDel(moved));
                end
                if isempty(moved)
                    % Count an iteration if phase 2 did nothing at all, or if we're
                    % in the middle of a pass through all the points
                    if (iter == iter1) || nummoved > 0
                        iter = iter + 1;
                        if display > 2 % 'iter'
                            fprintf(dispfmt,iter,2,length(moved),totsumD);
                        end
                    end
                    converged = true;
                    break;
                end
                
                % Pick the next move in cyclic order
                moved = mod(min(mod(moved - lastmoved - 1, n) + lastmoved), n) + 1;
                
                % If we've gone once through all the points, that's an iteration
                if moved <= lastmoved
                    iter = iter + 1;
                    if display > 2 % 'iter'
                        fprintf(dispfmt,iter,2,length(moved),totsumD);
                    end
                    if iter >= maxit, break; end
                    nummoved = 0;
                end
                nummoved = nummoved + 1;
                lastmoved = moved;
                
                oidx = idx(moved);
                nidx = nidx(moved);
                totsumD = totsumD + Del(moved,nidx) - Del(moved,oidx);
                
                % Update the cluster index vector, and the old and new cluster
                % counts and centroids
                idx(moved) = nidx;
                m(nidx) = m(nidx) + 1;
                m(oidx) = m(oidx) - 1;
                switch distance
                    case 'sqeuclidean'
                        C(nidx,:) = C(nidx,:) + (X(moved,:) - C(nidx,:)) / m(nidx);
                        C(oidx,:) = C(oidx,:) - (X(moved,:) - C(oidx,:)) / m(oidx);
                    case 'cityblock'
                        for i = [oidx nidx]
                            % Separate out sorted coords for points in each cluster.
                            % New centroid is the coord median, save values above and
                            % below median.  All done component-wise.
                            Xsorted = sort(X(idx==i,:),1);
                            nn = floor(.5*m(i));
                            if mod(m(i),2) == 0
                                C(i,:) = .5 * (Xsorted(nn,:) + Xsorted(nn+1,:));
                                Xmid(i,:,1:2) = Xsorted([nn, nn+1],:)';
                            else
                                C(i,:) = Xsorted(nn+1,:);
                                if m(i) > 1
                                    Xmid(i,:,1:2) = Xsorted([nn, nn+2],:)';
                                else
                                    Xmid(i,:,1:2) = Xsorted([1, 1],:)';
                                end
                            end
                        end
                    case {'cosine','correlation'}
                        C(nidx,:) = C(nidx,:) + (X(moved,:) - C(nidx,:)) / m(nidx);
                        C(oidx,:) = C(oidx,:) - (X(moved,:) - C(oidx,:)) / m(oidx);
                    case 'hamming'
                        % Update summed coords for points in each cluster.  New
                        % centroid is the coord median.  All done component-wise.
                        Xsum(nidx,:) = Xsum(nidx,:) + X(moved,:);
                        Xsum(oidx,:) = Xsum(oidx,:) - X(moved,:);
                        C(nidx,:) = 2*Xsum(nidx,:) > m(nidx);
                        C(oidx,:) = 2*Xsum(oidx,:) > m(oidx);
                end
                changed = sort([oidx nidx]);
            end % phase two
            
        end % nested function
        
    end

end % main function

%------------------------------------------------------------------

function D = distfun(X, C, dist, iter,rep, reps)
%DISTFUN Calculate point to cluster centroid distances.
[n,p] = size(X);
if isfloat(X)
    D = zeros(n,size(C,1),'like',X);
else % X can be logical
    D = zeros(n,size(C,1));
end

nclusts = size(C,1);

switch dist
    case 'sqeuclidean'
        for i = 1:nclusts
            D(:,i) = (X(:,1) - C(i,1)).^2;
            for j = 2:p
                D(:,i) = D(:,i) + (X(:,j) - C(i,j)).^2;
            end
            % D(:,i) = sum((X - C(repmat(i,n,1),:)).^2, 2);
        end
    case 'cityblock'
        for i = 1:nclusts
            D(:,i) = abs(X(:,1) - C(i,1));
            for j = 2:p
                D(:,i) = D(:,i) + abs(X(:,j) - C(i,j));
            end
            % D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2);
        end
    case {'cosine','correlation'}
        % The points are normalized, centroids are not, so normalize them
        normC = sqrt(sum(C.^2, 2));
        if any(normC < eps(class(normC))) % small relative to unit-length data points
            if reps==1
                error(message('stats:kmeans:ZeroCentroid', iter));
            else
                error(message('stats:kmeans:ZeroCentroidRep', iter, rep));
            end
            
        end
        
        for i = 1:nclusts
            D(:,i) = max(1 - X * (C(i,:)./normC(i))', 0);
        end
    case 'hamming'
        for i = 1:nclusts
            D(:,i) = abs(X(:,1) - C(i,1));
            for j = 2:p
                D(:,i) = D(:,i) + abs(X(:,j) - C(i,j));
            end
            D(:,i) = D(:,i) / p;
            % D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2) / p;
        end
end
end % function

%------------------------------------------------------------------

function [centroids, counts] = gcentroids(X, index, clusts, dist)
%GCENTROIDS Centroids and counts stratified by group.
p = size(X,2);
num = length(clusts);
if isfloat(X)
    centroids = NaN(num,p,'like',X);
    counts = zeros(num,1,'like',X);
else %X can be logic
    centroids = NaN(num,p);
    counts = zeros(num,1);
end

for i = 1:num
    members = (index == clusts(i));
    if any(members)
       counts(i) = sum(members);
       switch dist
            case 'sqeuclidean'
                centroids(i,:) = sum(X(members,:),1) / counts(i);
            case 'cityblock'
                % Separate out sorted coords for points in i'th cluster,
                % and use to compute a fast median, component-wise
                Xsorted = sort(X(members,:),1);
                nn = floor(.5*counts(i));
                if mod(counts(i),2) == 0
                    centroids(i,:) = .5 * (Xsorted(nn,:) + Xsorted(nn+1,:));
                else
                    centroids(i,:) = Xsorted(nn+1,:);
                end
            case {'cosine','correlation'}
                centroids(i,:) = sum(X(members,:),1) / counts(i); % unnormalized
            case 'hamming'
                % Compute a fast median for binary data, component-wise
                centroids(i,:) = 2*sum(X(members,:), 1) > counts(i);
        end
    end
end
end % function
