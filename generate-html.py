# -*- coding: utf-8 -*- 

import os
import glob

TIKA_PATH = "tika-app-1.24.1.jar"

def generate_out(pdf_file):
    out_file = os.path.join(os.path.dirname(pdf_file), 'scholarly.html')
    if not os.path.exists(out_file) or os.path.getsize(out_file) == 0:
        command = "java -jar %s -x %s > %s " % (TIKA_PATH, pdf_file, out_file)
        print(command)
        os.system(command)

for pdf_file in glob.glob('ethos-viral/*/*.pdf'):
    generate_out(pdf_file)
