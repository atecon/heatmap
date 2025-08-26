This GUI element provides a simplified interface to the "heatmap()"
function, which produces a plot of the numerical values of a matrix.

Most items should be self-explanatory (at least after reading the help
to the heatmap package). The colors used in the plot are customizable,
to some extent: the user can choose between three predefined palettes,
plus a custom one.

- The 'native' palette is Gnuplot's native color palette and ranges
  from black to bright yellow;
  
- the 'zerowhite' palette is meant to distinguish clearly between
  negative entries (in blue, the lower the darker) and positive ones
  (in red, the higher the darker); zero entries are white;

- the 'BW' palette is a black/white palette (the lighter the larger);

- for the 'custom' palette the user has to specify a 'coldest' and a
  'hottest' color . Both have to be specified as strings, in a format
  recognized by gnuplot, eg "yellow" or "#00aabb".
