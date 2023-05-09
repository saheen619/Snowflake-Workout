# -k option :By default when you compress a file using the “gzip” command you end up with a new file with the extension “.gz”.
# If you want to compress the file and keep the original file,
$ gzip -k customer_complaints.csv


# -d option :This option allows to decompress a file using the “gzip” command
$ gzip -d customer_complaints.csv.gz


# -v option: This option displays the name and percentage reduction for each file compressed or decompressed.
$ gzip -v customer_complaints.csv
# RESULT
# customer_complaints.csv:         83.2% -- replaced with customer_complaints.csv.gz