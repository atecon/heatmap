# DESCRIPTION

This package is intended for producing heatmap or contour plots: Heatmaps are 2-dimensional plots where you have a rectangular array of "tiles" whose colours carry the relevant information; contour plots draw lines where the information is displayed by joining points with the same value.

The package offers 2 public functions; both feature a limited degree of customisability via an "options" bundle (discussed later).

Moreover, a **menu entry** can be added under the "View" menu, which offers a simplified interface to the "heatmap" function.

# AVAILABLE FUNCTIONS

## heatmap(X, opts)

Arguments:
- X: matrix, required
- opts: bundle, optional (see below)

This function produces a heatmap or contour plot of a matrix,
depending on whether the `clevels` optional parameter is set (see
below).

## heatmap_func(func, res, x0, x1, y0, y1, opts)

Arguments:
- func: string
- res: scalar
- x0, x1: two scalars
- y0, y1: two scalars
- opts: bundle, optional

This function produces a heatmap plot of a two-variable function, with
resolution given by the scalar res.

The function to plot is evaluated on a rectangular mesh where *x* goes
from x0 to x1 and *y* goes from y0 to y1. Note: reasonable values for
the "res" parameter go from 50 to 400, but it really depends on the
context.

The function must be passed via the argument "func", which should
contain a string such that "func(x,y)" evaluates to a scalar. For
example, the native function "atan2" should work OK. To plot the
arc tangent function in the region x=±1, y=±1, use the line

```
heatmap_func("atan2", 40, -1, 1, -1, 1)
```

Optionally, a third parameter of matrix type can be passed to "func",
by including it into the options bundle under the key "fparam". For
example, the following code can be used for plotting the function
z = x^2 + 2*y^2 - 3*x*y

```
function scalar myfunc(scalar x, scalar y, matrix a)
	scalar ret = a[1] * x^2 + a[2] * y^2 + a[3] * x*y
	return ret
end function

bundle opts = null
opts.fparam = {1,2,-3}
heatmap_func("myfunc", 40, -1, 1, -1, 1, opts)
```

## contour_plot(X, opts[null], clevels[::8])

Arguments:
- X: matrix, required
- opts: bundle, optional
- clevels: scalar, optional (default = 8)

A small convenience wrapper that forces creation of a contour plot by setting the `clevels` option and delegating to heatmap(). If `clevels` is omitted the wrapper uses a sensible default (8).

## heatmap_plot(Input, opts[null])

Arguments:
- Input: numeric, required - accepts a matrix, or a list of series (time-series)
- opts: bundle, optional

A convenience wrapper for producing heatmaps from the common data shapes encountered in Gretl workflows. If a **matrix** is provided it is used as-is. For **time-series datasets** a list of series (at least two) is accepted and converted internally to a matrix (columns are series, rows are observations). For **panel datasets** a single panel series is accepted and the wrapper will reshape it so that each unit becomes a column and time runs along rows. **Cross-sectional** series are not supported by this wrapper. After conversion the call is forwarded to heatmap().

## pm3d_plot(Input, opts[null])

Arguments:
- Input: numeric, required - accepts a matrix (grid form), a matrix with three columns (x y z rows), or a list of three series (each series becomes a column and the list is transposed into Nx3 rows).
- opts: bundle, optional

Creates a 3-dimensional surface visualization by driving gnuplot's pm3d mode together with the splot command. Behaviour depends on the form of the input:
- Matrix form (cols != 3): the matrix is interpreted as a z-grid (rows/columns form a regular lattice). The plot uses the matrix data format understood by gnuplot.
- Table form (matrix with 3 columns or list of three series): the input is interpreted as an (x, y, z) table. If desired, the implementation may apply gnuplot's dgrid3d to interpolate scattered points onto a regular grid before plotting.

**Note:** This functionality is currently not accessible via the GUI menu.

Several options from the standard options bundle affect the pm3d plot (palette, limits, title, labels). In addition, pm3d-specific options are available:

### pm3d-specific options

- `grid_resolution`: scalar, controls the resolution used by gnuplot's dgrid3d interpolation when applied to table-style (x y z) inputs or when smoothing the surface. The default value is 25. Setting this to 0 disables dgrid3d interpolation.

- `view_x_axis`: scalar, controls the rotation of the plot around the x-axis. The default value is 60.

- `view_y_axis`: scalar, controls the rotation of the plot around the y-axis. The default value is 15.

- `with_contour`: boolean, when TRUE and the input is a matrix, the pm3d plot may be augmented with contour-plot so that contour lines on the base or are combined with the pm3d surface. The default value is FALSE.

These keys are present in the default options bundle and are only used by pm3d_plot().

The `grid` option from the standard bundle draws a grid on the surface of the plot when `TRUE`, which can help to visualize the data more clearly.


# OPTIONS

As for the options bundle, the active keys are:

## general parameters

- `dest`: string, the output file name. The default value is "display",
  which causes the plot to appear on screen
- `quiet`: boolean, don't print a completion message (default = FALSE)
- `fparam`: matrix, used in conjunction with the heatmap_func (see above)
- `clevels`: scalar, max number of levels for contour plots (see below)
- `grid`: boolean, plot a grid (white for heatmaps, see below for contour plots)

## colours

- `native`: boolean, use the native gnuplot palette; the default is
  FALSE for heatmap and TRUE for heatmap_func
- `limits`: matrix. A 2-element vector for controlling the minimum and
  maximum values for the colour palette. If either is set to NA, the
  min and max (respectively) of the input matrix will be used. This
  can be useful, for example, when plotting correlation matrices.
- `coldest`: string, colour for the minimum of the plotted values. This
  setting is active if the 'native' option is 0. It has to be in a
  format recognised by gnuplot, eg "black" or "#0000cc" (default =
  kind of reddish)
- `hottest`: string, colour for the maximum of the plotted values. This
  setting is active if the 'native' option is 0. It has to be in a
  format recognised by gnuplot, eg "white" or "#aa88ed" (default =
  kind of yellowish)
- `zerowhite`: boolean, useful for the cases when it is important to
  separate positive and negative values: if enabled, will colour 0
  entries as white (default = 0). This setting is active only if the
  'native' option is 0.

## strings and labels

- `title`: string, the plot title (default: none).
- `do_labels`: boolean, decorate the plot with x and y labels (default:
  false). If set to 1, the plot will use the row and column labels of
  the matrix, if present.
- `printvals`: an integer, controlling whether to print the matrix
  values in the plot. If negative, nothing is printed. If positive, it
  controls the number of decimals. (default = -1)
- `xlabel`: string, optional x-axis title
- `ylabel`: string, optional y-axis title

## font sizes

- `labelfs`: font size for the x- and y-titles (default = 14)
- `ticfs`: font size for the tic marks (default = 14)
- `titlefs`: font size for the plot title (default = 14)
- `valfs`: font size for the matrix values (default = 14)

## date options

When passing a time series or a list of time series to the `heatmap_plot()` function, you can specify the date format and rotation for the x-axis labels using the `date_format` and `date_rotate` options in the options bundle.

- `date_format`: string, the format for the x-axis date labels (default "%Y-%m")
- `date_rotate`: scalar, the rotation angle for the x-axis date labels (default 45)
- `date_offset_x`: scalar, the x-axis offset for the date labels (default -3.5)
- `date_offset_y`: scalar, the y-axis offset for the date labels (default -1.4)


# CONTOUR PLOTS

Starting from version 1.7, a contour plot can be produced instead of a heatmap. This happens if the `clevels` scalar in the option bundle is set to a value between 1 and 32. The number itself refers to the number of points on the z-axis that gnuplot will use for plotting the contour lines. Note that there is no predictable relationship between the `clevels` setting and the number of contour lines you're going to get, but in most cases, with higher numbers you should see more lines. With gretl 2023c or later, contour lines will be coloured  from blue (lower z) to red (higher).

Some options have no effects with contour plots, namely: "do_labels", "printvals", "native", "limits", "coldest", "hottest" and "zerowhite".

Conversely, the `clevels` setting is mandatory, for obvious reasons; the `grid` boolean key may be used for plotting a  -dimensional dotted grid.


# CHANGELOG
* 1.9 -> 2.0: add support for creating 3D-plot via `pm3d_plot()` function; add new wrapper functions `contour_plot()` and `heatmap_plot()`; new dependency on `string_utils.gfn` (using `struniq()`); Raise minimum Gretl version to 2023a.
* 1.8 -> 1.9: introduce adjustable font sizes (see the "correlations" example for a demonstration).
* 1.7 -> 1.8: extend the "grid" switch to heatmaps. Also, amend the "correlations" example to show the new feature.
* 1.6 -> 1.7: contour plots; "xlabel" and "ylabel" options.
* 1.5 -> 1.6: introduce the "limits" option. Enable "hottest" and "coldest" settings with "zerowhite". Switch to markdown for help.
* 1.4 -> 1.5: introduce the "printvals" option. (Internal) remove outdated "outfile" syntax.
* 1.3 -> 1.4: fix the zerowhite options when the matrix to plot has only positive or negative values; fix the column vector case.
* 1.21 -> 1.3: bugfix: comply with the version requirements for real (avoid _() in favour of defbundle()) and fix the "zerowhite" option when the matrix contains small numbers.
* 1.2 -> 1.21: bugfix: same as previous fix, done properly this time for earlier versions of gretl.
* 1.1 -> 1.2: bugfix: enforce decimal point when writing to gnuplot, so we don't have an error when running localised versions of gretl.
* 1.0 -> 1.1: introduce 'builtin' and 'quiet' options, produce a completion message and provide a GUI interface

