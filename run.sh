#!/bin/bash

matlab -nosplash -nodisplay -nodesktop -r "script(${1},${2}); exit"
