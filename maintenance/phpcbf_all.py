import glob
import os
from tqdm import tqdm
file_names = glob.glob('application/**/*.php')
for file_name in tqdm(file_names):
    file_name = file_name.replace('\\', '/')
    print('#' * 100)
    print('NEXT FILE:', file_name)
    print('#' * 100)
    os.system('PHPCBF ' + file_name)