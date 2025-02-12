% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SCP-workflow.R
\name{Integration_SCP}
\alias{Integration_SCP}
\title{Integration_SCP}
\usage{
Integration_SCP(
  srtMerge = NULL,
  batch = "orig.ident",
  append = TRUE,
  srtList = NULL,
  assay = "RNA",
  integration_method = "Uncorrected",
  do_normalization = NULL,
  normalization_method = "LogNormalize",
  do_HVF_finding = TRUE,
  HVF_source = "separate",
  HVF_method = "vst",
  nHVF = 2000,
  HVF_intersect = FALSE,
  HVF_min_intersection = 1,
  HVF = NULL,
  do_scaling = TRUE,
  vars_to_regress = NULL,
  regression_model = "linear",
  linear_reduction = "pca",
  linear_reduction_dims = 100,
  linear_reduction_dims_use = NULL,
  linear_reduction_params = list(),
  force_linear_reduction = FALSE,
  nonlinear_reduction = "umap",
  nonlinear_reduction_dims = c(2, 3),
  nonlinear_reduction_params = list(),
  force_nonlinear_reduction = TRUE,
  do_cluster_finding = TRUE,
  cluster_algorithm = "louvain",
  cluster_resolution = 0.6,
  cluster_reorder = TRUE,
  seed = 11,
  ...
)
}
\arguments{
\item{srtMerge}{A merged \code{Seurat} object with batch information.}

\item{batch}{Metadata column name containing the batch information.}

\item{append}{Whether append results into the \code{srtMerge}. Only valid when srtMerge is provided.}

\item{srtList}{A list of \code{Seurat} object.}

\item{integration_method}{Integration method. Can be one of "Uncorrected", "Seurat", "scVI", "MNN", "fastMNN", "Harmony", "Scanorama", "BBKNN", "CSS", "LIGER", "Conos".}

\item{do_normalization}{Whether to normalize the data. If NULL, will automatically determine.}

\item{normalization_method}{Normalization method.Can be one of "LogNormalize", "SCT".}

\item{do_HVF_finding}{Whether to find the high variable features(HVF). If NULL, will automatically determine.}

\item{HVF_source}{Source of the HVF. Can be one of "separate" and "global".}

\item{nHVF}{HVF number to use.}

\item{HVF_min_intersection}{}

\item{HVF}{Custom high variable features.}

\item{do_scaling}{Whether to scale the data. If NULL, will automatically determine.}

\item{vars_to_regress}{Variables to regress out.}

\item{regression_model}{Use a linear model or generalized linear model (poisson, negative binomial) for the regression. Options are "linear" (default), "poisson", and "negbinom".}

\item{linear_reduction}{linear reduction method name. Can be one of "pca", "ica", "nmf", "mds", "glmpca".}

\item{linear_reduction_dims}{Dimensions to calculate when performing linear reduction.}

\item{linear_reduction_dims_use}{Which dimensions to use when performing the nonlinear reduction.}

\item{nonlinear_reduction}{Non-linear reduction method name. Can be one of "umap", "umap-naive", "tsne", "dm", "phate", "pacmap", "trimap", "largevis".}

\item{nonlinear_reduction_dims}{Dimensions to calculate when performing non-linear reduction.}

\item{cluster_algorithm}{Algorithm for modularity optimization when finding clusters. Can be one of "louvain", "slm", "leiden".}

\item{cluster_resolution}{Cluster resolution parameter.}

\item{cluster_reorder}{Whether to reorder the cluster names using hierarchical clustering.}

\item{seed}{Set a random seed.}
}
\value{
A \code{Seurat} object containing the result.
}
\description{
Single cell pipeline for the integration of multiple datasets.
}
\examples{
data("panc8_sub")
panc8_sub <- Integration_SCP(
  srtMerge = panc8_sub, batch = "tech", integration_method = "Uncorrected"
)
ClassDimPlot(panc8_sub, group.by = c("tech", "celltype"))

panc8_sub <- Integration_SCP(
  srtMerge = panc8_sub, batch = "tech", integration_method = "Seurat"
)
ClassDimPlot(panc8_sub, group.by = c("tech", "celltype"))

panc8_sub <- Integration_SCP(
  srtMerge = panc8_sub, batch = "tech", integration_method = "Seurat",
  HVF_intersect = TRUE
)
ClassDimPlot(panc8_sub, group.by = c("tech", "celltype"))

panc8_sub <- Integration_SCP(
  srtMerge = panc8_sub, batch = "tech", integration_method = "Seurat",
  HVF_intersect = TRUE, HVF_min_intersection = length(unique(panc8_sub$tech))
)
ClassDimPlot(panc8_sub, group.by = c("tech", "celltype"))

\dontrun{
for (method in c("Uncorrected", "Seurat", "scVI", "MNN", "fastMNN", "Harmony", "Scanorama", "BBKNN", "CSS", "LIGER", "Conos")) {
  panc8_sub <- Integration_SCP(
    srtMerge = panc8_sub, batch = "tech",
    integration_method = method, nonlinear_reduction = "umap"
  )
  print(ClassDimPlot(panc8_sub, group.by = c("tech", "celltype"), reduction = paste0(method, "UMAP2D"), theme_use = "theme_blank"))
}

panc8_sub <- Integration_SCP(
  srtMerge = panc8_sub, batch = "tech", integration_method = "Seurat",
  nonlinear_reduction = c("umap", "tsne", "dm", "phate", "pacmap", "trimap", "largevis")
)
for (reduc in c("umap", "tsne", "dm", "phate", "pacmap", "trimap", "largevis")) {
  print(ClassDimPlot(panc8_sub, group.by = c("tech", "celltype"), reduction = paste0("Seurat", reduc, "2D"), theme_use = "theme_blank"))
}
}

}
