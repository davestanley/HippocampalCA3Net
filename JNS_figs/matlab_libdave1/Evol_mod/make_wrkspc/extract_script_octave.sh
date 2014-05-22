
# Usage:
#First entry = run mode (local or parallel on saguaro)
#Second entry = number of folders to traverse (should be max # of output folders)


currpath=`pwd`
dataoutput_path="./matlogs"
run_mode=$1
starting_index=$2
ending_index=$3
MAT_FILENAME_ROOT="sag_mat"
MAT_OUTPUTNAME_ROOT="sag_out"

cp ~/startup_Evol.m .

if [ -d $dataoutput_path ]; then		# Check if save directory already exists
	echo Output directory \"${dataoutput_path}\" already exists. Exiting…
	exit 0
fi
mkdir $dataoutput_path



for (( c=${starting_index}; c<=${ending_index}; c++ ))
do
	MAT_FILENAME=${MAT_FILENAME_ROOT}${c}""
	echo "startup_Evol" > ${MAT_FILENAME}.m
	echo "make_wrkspc(${c});" >> ${MAT_FILENAME}.m
	echo "exit" >> ${MAT_FILENAME}.m
	sleep 1
#	"export PATH=$PATH; export TERM=$TERM; cd $currpath; matlab -nodesktop -nodisplay -nosplash -r $MAT_FILENAME > ${MAT_OUTPUTNAME_ROOT}${c}.txt"


if [ $run_mode = 1 ]; then
	octave --eval $MAT_FILENAME > ${MAT_OUTPUTNAME_ROOT}${c}.txt; mv ${MAT_FILENAME}.m ${dataoutput_path}/; mv ${MAT_OUTPUTNAME_ROOT}${c}.txt ${dataoutput_path}/; mv wrkspc_${c}.mat ${dataoutput_path}/
elif [ $run_mode = 5 ]; then
	echo QSub to saguaro.
	qsub <<< "export PATH=$PATH; export TERM=$TERM; cd $currpath; use MatlabR2010a; matlab -nodesktop -nodisplay -nosplash -r $MAT_FILENAME > ${MAT_OUTPUTNAME_ROOT}${c}.txt; mv ${MAT_FILENAME}.m ${dataoutput_path}/; mv ${MAT_OUTPUTNAME_ROOT}${c}.txt ${dataoutput_path}/; mv wrkspc_${c}.mat ${dataoutput_path}/"
	echo qsub <<< "export PATH=$PATH; export TERM=$TERM; cd $currpath; use MatlabR2010a; matlab -nodesktop -nodisplay -nosplash -r $MAT_FILENAME > ${MAT_OUTPUTNAME_ROOT}${c}.txt; mv ${MAT_FILENAME}.m ${dataoutput_path}/; mv ${MAT_OUTPUTNAME_ROOT}${c}.txt ${dataoutput_path}/; mv wrkspc_${c}.mat ${dataoutput_path}/"
fi
	
	
	
done



#currpath=`pwd`
#SERVER=dominique.asu.edu
#stepsize=21
#startingfile=1
#endfile=21
#
#
#numfiles=$(($endfile-$startingfile+1))
#overhang=$(($numfiles % $stepsize))
#numprocs=0
#
#
#for (( c=$startingfile; c<=$(($endfile-$overhang-$stepsize+1)); c+= $stepsize ))
#do
#	echo "Running matlab with: for_range=$c:$(($c+$stepsize-1));"
#	echo "for_range=$c:$(($c+$stepsize-1));" > rangefile.m	
#	sleep 2
#	numprocs=$(($numprocs+1))
#	ssh $SERVER "export PATH=$PATH; export TERM=$TERM; cd $currpath; matlab -nodesktop -nodisplay -nosplash -r extract_all_fields > deleteme_$numprocs.out" &
#	sleep 15
#	
#done
#
#if (( $(($numfiles % stepsize)) != 0 ))
#then
#	echo "Running matlab with: for_range=$(($endfile-$overhang+1)):$endfile;"
#	echo "for_range=$(($endfile-$overhang+1)):$endfile;" > rangefile.m
#	sleep 2
#	numprocs=$(($numprocs+1))
#	ssh $SERVER "export PATH=$PATH; export TERM=$TERM; cd $currpath; matlab -nodesktop -nodisplay -nosplash -r extract_all_fields > deleteme_$numprocs.out" &
#	sleep 15
#
#fi
