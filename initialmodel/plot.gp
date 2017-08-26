set terminal postscript eps enhanced color font 'H,25'



reset
set logscale y
set format y "10^{%T}"
set xlabel "height [km]" font "H,30"
set ylabel "density[g/cm^3]" font "H,30"
set output 'density_height.ps'
set style line 10 linewidth 1.000 dashtype 1 pointtype 7 pointsize 1.0 pointinterval 0 lc 7
set style line 11 linewidth 1.000 dashtype 1 pointtype 6 pointsize 1.0 pointinterval 0 lc rgb"red"
set style line 12 linewidth 1.000 dashtype 1 pointtype 4 pointsize 1.0 pointinterval 0 lc rgb"blue"
set style line 40 linewidth 2.000 dashtype 1 pointtype 1 pointsize 2.0 pointinterval 0 lc "#008000"


set style line 21 linewidth 10.000 dashtype 1 pointtype 6 pointsize 3.0 pointinterval 0 lc rgb"red"
set style line 22 linewidth 6.000 dashtype 1 pointtype 6 pointsize 2.0 pointinterval 0 lc rgb"red"
set style line 23 linewidth 4.000 dashtype 1 pointtype 6 pointsize 1.5 pointinterval 0 lc rgb"red"

set style line 31 linewidth 10.000 dashtype 1 pointtype 7 pointsize 3.0 pointinterval 0 lc rgb"blue"
set style line 32 linewidth 6.000 dashtype 1 pointtype 7 pointsize 2.0 pointinterval 0 lc rgb"blue"
set style line 33 linewidth 4.000 dashtype 1 pointtype 7 pointsize 1.5 pointinterval 0 lc rgb"blue"

set xtics 20000
set key bottom right
set yrange[10**-23:]
!set label "y=10^{8}km" at graph 0.03,0.1 font "H-bold,25"
!set label "error=|[P(i)-P(i-1)]/[y(i)-y(i-1)]-g({/Symbol r}(i)+{/Symbol r}(i-1))/2|" at graph 0.03,0.95 font "H,15"
plot \
"newmodelcpp.hse" using ($1/10**5):2 notitle "cell # 512" with lines ls 11,\


reset
set logscale y
set format y "10^{%T}"
set xlabel "height [km]" font "H,30"
set ylabel "pressure[bar]" font "H,30"
set output 'pressure_height.ps'
set style line 10 linewidth 1.000 dashtype 1 pointtype 7 pointsize 1.0 pointinterval 0 lc 7
set style line 11 linewidth 1.000 dashtype 1 pointtype 6 pointsize 1.0 pointinterval 0 lc rgb"red"
set style line 12 linewidth 1.000 dashtype 1 pointtype 4 pointsize 1.0 pointinterval 0 lc rgb"blue"
set style line 40 linewidth 2.000 dashtype 1 pointtype 1 pointsize 2.0 pointinterval 0 lc "#008000"


set style line 21 linewidth 10.000 dashtype 1 pointtype 6 pointsize 3.0 pointinterval 0 lc rgb"red"
set style line 22 linewidth 6.000 dashtype 1 pointtype 6 pointsize 2.0 pointinterval 0 lc rgb"red"
set style line 23 linewidth 4.000 dashtype 1 pointtype 6 pointsize 1.5 pointinterval 0 lc rgb"red"

set style line 31 linewidth 10.000 dashtype 1 pointtype 7 pointsize 3.0 pointinterval 0 lc rgb"blue"
set style line 32 linewidth 6.000 dashtype 1 pointtype 7 pointsize 2.0 pointinterval 0 lc rgb"blue"
set style line 33 linewidth 4.000 dashtype 1 pointtype 7 pointsize 1.5 pointinterval 0 lc rgb"blue"

set xtics 20000
set key bottom right
!set label "y=10^{8}km" at graph 0.03,0.1 font "H-bold,25"
!set label "error=|[P(i)-P(i-1)]/[y(i)-y(i-1)]-g({/Symbol r}(i)+{/Symbol r}(i-1))/2|" at graph 0.03,0.95 font "H,15"
plot \
"newmodelcpp.hse" using ($1/10**5):($4/10**6) notitle "cell # 512" with lines ls 11,\




reset
set logscale y
set format y "10^{%T}"
set xlabel "height [km]" font "H,30"
set ylabel "T[K]" font "H,30"
set output 'density_T.ps'
set style line 10 linewidth 1.000 dashtype 1 pointtype 7 pointsize 1.0 pointinterval 0 lc 7
set style line 11 linewidth 1.000 dashtype 1 pointtype 6 pointsize 1.0 pointinterval 0 lc rgb"red"
set style line 12 linewidth 1.000 dashtype 1 pointtype 4 pointsize 1.0 pointinterval 0 lc rgb"blue"
set style line 40 linewidth 2.000 dashtype 1 pointtype 1 pointsize 2.0 pointinterval 0 lc "#008000"


set style line 21 linewidth 10.000 dashtype 1 pointtype 6 pointsize 3.0 pointinterval 0 lc rgb"red"
set style line 22 linewidth 6.000 dashtype 1 pointtype 6 pointsize 2.0 pointinterval 0 lc rgb"red"
set style line 23 linewidth 4.000 dashtype 1 pointtype 6 pointsize 1.5 pointinterval 0 lc rgb"red"

set style line 31 linewidth 10.000 dashtype 1 pointtype 7 pointsize 3.0 pointinterval 0 lc rgb"blue"
set style line 32 linewidth 6.000 dashtype 1 pointtype 7 pointsize 2.0 pointinterval 0 lc rgb"blue"
set style line 33 linewidth 4.000 dashtype 1 pointtype 7 pointsize 1.5 pointinterval 0 lc rgb"blue"

set xtics 20000
set key bottom right
!set label "y=10^{8}km" at graph 0.03,0.1 font "H-bold,25"
!set label "error=|[P(i)-P(i-1)]/[y(i)-y(i-1)]-g({/Symbol r}(i)+{/Symbol r}(i-1))/2|" at graph 0.03,0.95 font "H,15"
plot \
"newmodelcpp.hse" using ($1/10**5):3 notitle "cell # 512" with lines ls 11,\



reset
set logscale y
set format y "10^{%T}"
set xlabel "height [km]" font "H,30"
set ylabel "c_{s}[cm/s]" font "H,30"
set output 'cs_T.ps'
set style line 10 linewidth 1.000 dashtype 1 pointtype 7 pointsize 1.0 pointinterval 0 lc 7
set style line 11 linewidth 1.000 dashtype 1 pointtype 6 pointsize 1.0 pointinterval 0 lc rgb"red"
set style line 12 linewidth 1.000 dashtype 1 pointtype 4 pointsize 1.0 pointinterval 0 lc rgb"blue"
set style line 40 linewidth 2.000 dashtype 1 pointtype 1 pointsize 2.0 pointinterval 0 lc "#008000"


set style line 21 linewidth 10.000 dashtype 1 pointtype 6 pointsize 3.0 pointinterval 0 lc rgb"red"
set style line 22 linewidth 6.000 dashtype 1 pointtype 6 pointsize 2.0 pointinterval 0 lc rgb"red"
set style line 23 linewidth 4.000 dashtype 1 pointtype 6 pointsize 1.5 pointinterval 0 lc rgb"red"

set style line 31 linewidth 10.000 dashtype 1 pointtype 7 pointsize 3.0 pointinterval 0 lc rgb"blue"
set style line 32 linewidth 6.000 dashtype 1 pointtype 7 pointsize 2.0 pointinterval 0 lc rgb"blue"
set style line 33 linewidth 4.000 dashtype 1 pointtype 7 pointsize 1.5 pointinterval 0 lc rgb"blue"

set xtics 20000
set key bottom right
!set label "y=10^{8}km" at graph 0.03,0.1 font "H-bold,25"
!set label "error=|[P(i)-P(i-1)]/[y(i)-y(i-1)]-g({/Symbol r}(i)+{/Symbol r}(i-1))/2|" at graph 0.03,0.95 font "H,15"
plot \
"newmodelcpp.hse" using ($1/10**5):(sqrt($4/$2)) notitle "cell # 512" with lines ls 11,\


reset
set logscale y
set format y "10^{%T}"
set xlabel "height [km]" font "H,30"
set ylabel "crossing time[s]" font "H,30"
set output 'crossingtime_T.ps'
set style line 10 linewidth 1.000 dashtype 1 pointtype 7 pointsize 1.0 pointinterval 0 lc 7
set style line 11 linewidth 1.000 dashtype 1 pointtype 6 pointsize 1.0 pointinterval 0 lc rgb"red"
set style line 12 linewidth 1.000 dashtype 1 pointtype 4 pointsize 1.0 pointinterval 0 lc rgb"blue"
set style line 40 linewidth 2.000 dashtype 1 pointtype 1 pointsize 2.0 pointinterval 0 lc "#008000"


set style line 21 linewidth 10.000 dashtype 1 pointtype 6 pointsize 3.0 pointinterval 0 lc rgb"red"
set style line 22 linewidth 6.000 dashtype 1 pointtype 6 pointsize 2.0 pointinterval 0 lc rgb"red"
set style line 23 linewidth 4.000 dashtype 1 pointtype 6 pointsize 1.5 pointinterval 0 lc rgb"red"

set style line 31 linewidth 10.000 dashtype 1 pointtype 7 pointsize 3.0 pointinterval 0 lc rgb"blue"
set style line 32 linewidth 6.000 dashtype 1 pointtype 7 pointsize 2.0 pointinterval 0 lc rgb"blue"
set style line 33 linewidth 4.000 dashtype 1 pointtype 7 pointsize 1.5 pointinterval 0 lc rgb"blue"

set xtics 20000
set key bottom right
!set label "y=10^{8}km" at graph 0.03,0.1 font "H-bold,25"
!set label "error=|[P(i)-P(i-1)]/[y(i)-y(i-1)]-g({/Symbol r}(i)+{/Symbol r}(i-1))/2|" at graph 0.03,0.95 font "H,15"
plot \
"newmodelcpp.hse" using ($1/10**5):(10**10/3./sqrt($4/$2)) notitle "cell # 512" with lines ls 11,\

