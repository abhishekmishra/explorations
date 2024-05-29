# Lissajous Curve Parameters
A = 1            # Amplitude along x-axis
B = 1            # Amplitude along y-axis
a = 5            # Frequency along x-axis
b = 4            # Frequency along y-axis
omega = pi / 4   # Angular frequency of the phase difference

# Time range
set xrange [-1.5:1.5]
set yrange [-1.5:1.5]
set samples 1000

# Define parametric mode
set parametric
set trange [0:2*pi]

# Define the equations with time-dependent delta
delta(t) = omega * t
x(t) = A * sin(a * t + delta(t))
y(t) = B * sin(b * t)

# Plot the Lissajous curve
plot x(t), y(t) title 'Lissajous Curve with Variable Delta' with lines lw 2

# Additional plot settings
set title 'Lissajous Curve with Variable Delta'
set xlabel 'x(t)'
set ylabel 'y(t)'
set grid
set size ratio -1

# Refresh the plot
replot
