#!/bin/sh

DAY=$(date +"%d")
MONTH=$(date +"%b")
YEAR=$(date +"%Y")
TIME=$(date +"%H%M%S")

TEST_TIME=$DAY$MONTH$YEAR-$TIME

unameOut=$(uname -a)

case "${unameOut}" in
    Linux*)
        OUTDIR=results/$MONTH/Hyva-$TEST_TIME
        LOG_PATH=$OUTDIR/report.html
    ;;
    Darwin*)
        cd "$(dirname "$0")"
        OUTDIR=results/$MONTH/Hyva-$TEST_TIME
        LOG_PATH=$OUTDIR/report.html
    ;;
    *)
        OUTDIR=results\\$MONTH\\Hyva-$TEST_TIME
        LOG_PATH=$OUTDIR\\report.html
    ;;
esac

case "${unameOut}" in
    Linux*)
        robot -d $OUTDIR --output $DAY$MONTH$YEAR-alltestcase.xml test
    ;;
    Darwin*)
        robot -d $OUTDIR --output $DAY$MONTH$YEAR-alltestcase.xml test
    ;;
    MINGW*)
        robot -d $OUTDIR --output $DAY$MONTH$YEAR-alltestcase.xml test
    ;;
    Msys*)
        robot -d $OUTDIR --output $DAY$MONTH$YEAR-alltestcase.xml test
    ;;
    *)              
        echo "UNKNOWN SISTEM OPERATION: ${unameOut}"
    ;;
esac

case "${unameOut}" in
    Linux*)
        xdg-open $LOG_PATH
    ;;
    Darwin*)
        open $LOG_PATH
    ;;
    Msys*)
        explorer $LOG_PATH
    ;;
    MINGW*)
        explorer $LOG_PATH
    ;;
    *)
        echo "Result: $LOG_PATH"
    ;;
esac