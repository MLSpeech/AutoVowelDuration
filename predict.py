
import sys
import argparse
from subprocess import call
import front_end.extract_features as fe
import utils.run_back_end as model
import utils.label2textgrid as l2t
from utils.utilities import *
from sys import platform as _platform

__author__ = 'yossiadi'


def bin_platform():
    bin_directory = "."
    if _platform == "linux" or _platform == "linux2":
        bin_directory = "bin/_Linux_Release"
    elif _platform == "darwin":
        bin_directory = "bin/_Darwin_Release"
    elif _platform == "win32":
        print "Error: Windows platform not supported"
        exit(-1)
    return bin_directory


# run system commands
def easy_call(command):
    try:
        call(command, shell=True)
    except Exception as exception:
        print "Error: could not execute the following"
        print ">>", command
        print type(exception)     # the exception instance
        print exception.args      # arguments stored in .args
        exit(-1)


def main(wav_filename, output_textgrid_filename, csv_filename):

    # convert the wav file to 16khz sample rate
    print "Converting the wav file to 16khz sample rate"
    #tmp_wav16_filename = wav_filename.replace(".wav", "_16.wav")
    tmp_wav16_filename = generate_tmp_filename("wav")
    cmd = "front_end/" + bin_platform() + "/sox %s -r 16000 %s" % (wav_filename, tmp_wav16_filename)
    easy_call(cmd)

    # consts
    tmp_data_filename = generate_tmp_filename("data")
    tmp_labels_filename = generate_tmp_filename("labels")

    # validation
    if not os.path.exists(tmp_wav16_filename):
        print >>sys.stderr, "wav file %s does not exits" % tmp_wav16_filename
        return

    abs_wav_filename = os.path.abspath(wav_filename)
    abs_textgrid_filename = os.path.abspath(output_textgrid_filename)

    # extract the features - the front end part
    os.chdir("front_end/")
    fe.main(tmp_wav16_filename, tmp_data_filename)
    os.chdir("../")

    os.chdir("utils/")
    # predict the vowel onset and offset
    model.main(tmp_data_filename, tmp_labels_filename)
    # convert the predictions into text grid file
    l2t.main(tmp_labels_filename, abs_wav_filename, abs_textgrid_filename, csv_filename)
    os.chdir("../")

    # remove leftovers
    os.remove(tmp_wav16_filename)
    os.remove(tmp_data_filename)
    os.remove(tmp_labels_filename)

if __name__ == "__main__":
    # the first argument is the wav file path
    # the second argument is the TextGrid path
    # -------------MENU-------------- #
    # command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("wav_file_name", help="The wav file")
    parser.add_argument("output_text_grid_file", help="The output text grid file")
    parser.add_argument("--csv_output", help="Output results to a CSV file")
    args = parser.parse_args()

    # main function
    main(args.wav_file_name, args.output_text_grid_file, args.csv_output)
