rm rendered/*.stl
for part in base cover fill pick peel combo open
do
	for length in 6 12 24
	do
		if [ "$part" = "base" ]; then
			for depth in 4 8 12 16
			do
				echo "Rendering ${part}_${length}u-${depth}mm_depth.stl"
				openscad -o rendered/${part}_${length}u-${depth}.stl -D 'print="base"' -D "block_l=${length}" -D "tape_d=${depth}" P1-Drag_tape_feeder.scad
			done
		else
			for width in 8
			do
		
				echo "Rendering ${part}_${length}u-${width}mm_width.stl"
				openscad -o rendered/${part}_${length}u-${depth}.stl -D 'print="base"' -D "block_l=${length}" -D "tape_w=${width}" P1-Drag_tape_feeder.scad
			done
		fi
	done
done
