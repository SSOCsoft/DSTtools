FUNCTION Andor_Zyla_chronological_file_order, andor_files

;andor_files = FILE_SEARCH('*spool.dat')

files_to_sort = STRARR(N_ELEMENTS(andor_files))
FOR i = 0,(N_ELEMENTS(andor_files)-1) DO BEGIN &$
   element_1 = STRMID(andor_files[i],18,1,/reverse_offset) &$
   element_2 = STRMID(andor_files[i],17,1,/reverse_offset) &$
   element_3 = STRMID(andor_files[i],16,1,/reverse_offset) &$
   element_4 = STRMID(andor_files[i],15,1,/reverse_offset) &$
   element_5 = STRMID(andor_files[i],14,1,/reverse_offset) &$
   element_6 = STRMID(andor_files[i],13,1,/reverse_offset) &$
   element_7 = STRMID(andor_files[i],12,1,/reverse_offset) &$
   element_8 = STRMID(andor_files[i],11,1,/reverse_offset) &$
   element_9 = STRMID(andor_files[i],10,1,/reverse_offset) &$
   element_10 = STRMID(andor_files[i],9,1,/reverse_offset) &$
   files_to_sort[i] = STR2ARR(element_10 + element_9 + element_8 + element_7 + element_6 + element_5 + element_4 + element_3 + element_2 + element_1) &$
ENDFOR   

order = SORT(files_to_sort)
new_files = andor_files[order]

;image = READ_BINARY(new_files[0],DATA_DIMS=[2060,2050],DATA_TYPE=2)

RETURN, new_files

END
