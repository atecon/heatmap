# DESCRIPTION

This package produces heatmap, contour and 3D pm3d plots using gnuplot. Heatmaps display a rectangular array of tiles whose colours represent values; contour plots connect equal-value points with lines; pm3d plots render a coloured 3D surface using gnuplot's pm3d/splot features.

The package provides a small set of public wrappers and an options bundle to customise appearance and behaviour.

Please ask questions and report bugs on the Gretl mailing list if possible. Alternatively, create an issue ticket on the github repo (see below).
Source code and test script(s) can be found here: https://github.com/atecon/heatmap

# AVAILABLE FUNCTIONS

## heatmap(X, opts)

Arguments:

- X: matrix, required
- opts: bundle, optional (see OPTIONS)

Produces a heatmap of matrix X. If `clevels` in opts is set (>0) a contour plot is produced instead.

## heatmap_func(func, res, x0, x1, y0, y1, opts)

Arguments:

- func: string (name of function to evaluate)
- res: scalar (resolution)
- x0, x1: scalars (x range)
- y0, y1: scalars (y range)
- opts: bundle, optional

This function produces a heatmap plot of a two-variable function, with resolution given by the scalar `res`.

The function to plot is evaluated on a rectangular mesh where *x* goes from `x0` to `x1` and *y* goes from `y0` to `y1`.

Note: reasonable values for the `res` parameter go from 50 to 400, but it really depends on the context.

The function must be passed via the argument `func`, which should contain a string such that `func(x,y)` evaluates to a scalar. For example, the native function `atan2` should work OK. To plot the arc tangent function in the region x=±1, y=±1, use the line

```
heatmap_func("atan2", 40, -1, 1, -1, 1)
```

Optionally, a third parameter of matrix type can be passed to "func", by including it into the options bundle under the key `fparam`. For example, the following code can be used for plotting the function z = x^2 + 2*y^2 - 3*x*y

```
function scalar myfunc(scalar x, scalar y, matrix a)
	scalar ret = a[1] * x^2 + a[2] * y^2 + a[3] * x*y
	return ret
end function

bundle opts = null
opts.fparam = {1,2,-3}
heatmap_func("myfunc", 40, -1, 1, -1, 1, opts)
```


## heatmap_plot(Input, opts)

Arguments:

- Input: numeric, required — accepts a matrix, a list of time-series, or a panel series
- opts: bundle, optional

Convenience wrapper that converts common Gretl data shapes to a matrix and calls `heatmap()`.

## contour_plot(X, opts[null])

Arguments:

- X: matrix, required
- opts: bundle, optional

Convenience wrapper that forces a contour plot by setting `clevels` and delegating to `heatmap()`.

## pm3d_plot(Input, opts[null])

Arguments:

- Input: numeric, required — accepts:
  - a matrix with cols != 3: interpreted as a z-grid (regular lattice)
  - a matrix with 3 columns: interpreted as rows of (x y z)
  - a matrix with 2 columns and an additional column for date values passed by `obsdate` in opts (see example)
  - a list of three series: combined into an Nx3 (x,y,z) table
- opts: bundle, optional

Creates a 3D surface using gnuplot's pm3d and splot. Table-style inputs (x y z) may be interpolated with `dgrid3d` controlled by `grid_resolution`.

_NOTE:_ pm3d plotting is not currently exposed via the GUI menu in this version.

# OPTIONS

The functions accept a bundle of options. Common keys are listed here; only keys relevant to the user are shown.

# General parameters

- `clevels`: scalar, max number of levels for contour plots (see below)
- `dest`: string — output file name; default "display" (show on screen)
- `fparam`: matrix, used in conjunction with the heatmap_func (see above)
- `grid`: boolean — enable plotting grid / smoothing (varies by plot type) (default = FALSE but TRUE for pm3d plot)
- `quiet`: boolean — suppress completion message (default = FALSE)


## Colours and palette

- `native`: boolean — if TRUE use native palette; for pm3d the default is the MATLAB-like "jet" palette unless overridden
- `limits`: matrix — {min, max} for the color scale; NA for automatic
- `coldest`: string — color for minimum (when native = FALSE)
- `hottest`: string — color for maximum (when native = FALSE)
- `zerowhite`: boolean — paint zero values white (when native = FALSE)

## Labels, tics and fonts

- `title`, `xlabel`, `ylabel`, `zlabel`: strings for axis/title labels
- `do_labels`: boolean — use matrix row/column names for axis tics
- `printvals`: integer — print matrix values inside tiles (heatmap)
- `tics_out`: boolean — draw tics outside the plot
- `labelfs`, `ticfs`, `titlefs`, `valfs`: scalars — font sizes

## Date-related options

When passing time-series data or obsdate for an axis:

- `date_format`: string (e.g. "%Y-%m")
- `date_rotate`: scalar — rotation angle for date labels
- `date_offset_x`, `date_offset_y`: scalar — offset for date labels
- `max_date_tics`: scalar — max number of date tics to avoid clutter
- `obsaxis`: string — which axis to use for obsdate ("x", "y", or "z")
- `obsdate`: matrix — column vector of ISO8601 integers (YYYYMMDD or YYYYMM)

## pm3d-specific options

- `colorbox`: boolean — draw colorbox legend (pm3d only; default = TRUE)
- `colorbox_size`: matrix {w,h} — user size for colorbox (pm3d only)
- `colorbox_position`: matrix {x,y} — user position for colorbox (pm3d only)
- `grid_resolution`: scalar — resolution for gnuplot dgrid3d interpolation when producing a grid from (x,y,z) tables (default 25). Set to 0 to disable dgrid3d.
- `with_contour`: boolean — if TRUE, combine contour/hidden3d settings with pm3d rendering (useful for matrix inputs).
- `view_x_axis`, `view_y_axis`: scalars — control rotation/view angles for `set view` (defaults commonly 50,35)
- `xrange_min`, `xrange_max`, `yrange_min`, `yrange_max`, `zrange_min`, `zrange_max`: scalars — explicit axis ranges (NA for auto)

These pm3d keys are present in the package default options bundle but are only used by `pm3d_plot()`.

# CONTOUR PLOTS

Set `clevels` in the options bundle to produce contour plots from matrices. Typical values are between 1 and 32; the convenience wrapper `contour_plot()` defaults to 8. You may also pass `contour_levels` (vector) to set discrete contour levels and `isosamples` (2-element vector) to control sampling resolution.

Some keys have no effect with contour plots: `do_labels`, `printvals`, `native`, `limits`, `coldest`, `hottest`, `zerowhite`.

# NOTES & EXAMPLES (brief)

- Heatmap from matrix: heatmap(A)
- Contour from matrix: contour_plot(A, _(clevels=12))
- pm3d from grid matrix: pm3d_plot(M)
- pm3d from (x,y,z) table: pm3d_plot(tbl, _(grid_resolution=50))
- pm3d from list of three series: pm3d_plot({s1,s2,s3})

# CHANGELOG (highlights)

* 2.0: add pm3d_plot(), improved wrappers, pm3d options, many new options
* 1.9: adjustable font sizes, improved palettes
* 1.7: contour plots

