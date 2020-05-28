# -*- coding: utf-8 -*- 

import os
import glob

TIKA_PATH = "tika-app-1.24.1.jar"

def generate_txt(pdf_file):
    txt_file = os.path.join(os.path.dirname(pdf_file), 'fulltext.pdf.txt')
    if not os.path.exists(txt_file) or os.path.getsize(txt_file) == 0:
        command = "java -jar %s -t %s > %s " % (TIKA_PATH, pdf_file, txt_file)
        print(command)
        os.system(command)

for pdf_file in glob.glob('ethos-viral/*/*.pdf'):
    print(pdf_file)
    generate_txt(pdf_file)
