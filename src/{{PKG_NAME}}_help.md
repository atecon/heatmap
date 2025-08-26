# {{PKG_NAME}}

This package includes functionalities to identify unknown clusters of multidimensional data using the well known (at least in the machine-learning field) k-means algorithm.


For more information see:

https://scikit-learn.org/stable/modules/clustering.html#kmeans


## GUI access

Currently, only k-means estimation but not silhouette analysis can be performed via the dialog box, which can be opened via `View -> k-Means`.

Two choices are available:

1. If you activate the checkbox "Show scree plot" the scree plot will be shown, and the parameter `n_clusters` is the maximum number of clusters to evaluate and plot. The returned bundle will contain only a matrix with two columns: the first column is the number of clusters, and the second column is the within-cluster sum of squares (*inertia*). Each row corresponds to a different number of clusters.

2. If you activate the checkbox "Show pair-plot" the pair-plot will be shown, and the parameter `n_clusters` is the number of clusters to estimate. The returned bundle will contain detailed information about the estimation.


# Public Functions

## kmeans_fit

```
kmeans_fit (list xlist, int n_clusters[2::2], bundle opts[null])
```

Execute the kmeans algorithm and estimate the clusters. It is required that `xlist` does not contain missing values. So, please make sure to clean the data before calling this function.

**Arguments:**

- `xlist`: list, Features (regressors) to train the model.
- `n_clusters`: int, Number of assumed clusters (default: 2)
- `opts`: bundle, Optional parameters affecting the kmeans algorithm. **You can pass the following parameters:**

    * `algorithm`: string, kmeans algorithm to use. Currently, only `full` is supported (classical EM-style algorithm).

**Return:** Bundle holding various items.

- `between_variation`: scalar, Between cluster sum of squares = `total_ssq - within_variation_total`



## kmeans_screeplot

```
kmeans_screeplot (list xlist, int max_clusters, string filename[null], bundle self[null])
```

This function plots the scree plot for the kmeans algorithm. The scree plot shows the within-cluster sum of squares (*inertia*) for different numbers of clusters (from 1 to `max_clusters`). The optimal number of clusters is the one where the within-cluster sum of squares starts to decrease more slowly.

**Arguments:**

- `xlist`: list, Features (regressors) used for plotting.
- `max_clusters`: int, Maximum number of clusters to plot (default: 3).
- `filename`: string, Name of the file to save the plot (optional). If not provided, the plot will be shown on the screen.
- `self`: bundle, Bundle for manipulating the plot (optional). **Note, accepted options are:**

    * The same as for the `kmeans_fit()` function for the `opts` bundle. Relevant for controlling the k-means algorithm.
    * `verbose`: int, If `2` show summary for each model, else show nothing.
    * `fontsize`: scalar, Font size for the plot.
    * `linewidth`: scalar, Line width for the plot.

**Return:** Matrix with two columns: the first column is the number of clusters, and the second column is the within-cluster sum of squares (*inertia*). Each row corresponds to a different number of clusters.



# Changelog

* **v0.6 (August 2025)**
    * Add new silhouette functions: `kmeans_sil_samples()`, `kmeans_sil_score()`, and `kmeans_sil_plot()`
