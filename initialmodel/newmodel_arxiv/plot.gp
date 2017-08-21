set terminal postscript eps enhanced color font 'H,25'



reset
set logscale y
set format y "10^{%T}"
set xlabel "cell index i" font "H,30"
set ylabel "error" font "H,30"
set output 'error.ps'
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


set key bottom right
set label "y=10^{8}km" at graph 0.03,0.1 font "H-bold,25"
set label "error=|[P(i)-P(i-1)]/[y(i)-y(i-1)]-g({/Symbol r}(i)+{/Symbol r}(i-1))/2|" at graph 0.03,0.95 font "H,15"
plot \
"/Users/taehoryu/Desktop/project/project7.HotJupiter/planet/newmodel/error_128.txt" using 1:3 title "cell # 128" with points ls 12,\
"/Users/taehoryu/Desktop/project/project7.HotJupiter/planet/newmodel/error_256.txt" using 1:3 title "cell # 256" with points ls 10,\
"/Users/taehoryu/Desktop/project/project7.HotJupiter/planet/newmodel/error_512.txt" using 1:3 title "cell # 512" with points ls 11,\

