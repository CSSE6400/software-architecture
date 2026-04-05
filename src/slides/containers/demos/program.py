#!/usr/bin/env python3

import numpy as np
import re

my_arr = np.array([5, 2, 9, 7, 3])
max_element = np.max(my_arr)

duplicated_max = re.sub(".*", f"{max_element}", "X")
print(sum(int(x) for x in duplicated_max))
