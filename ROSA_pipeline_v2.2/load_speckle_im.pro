function load_speckle_im, filename, dim, endian=endian
;+
;;Program to read in unformatted binary image.
;;
;;load_speckle_im, file, dim,endian=endian
;;
;;PARAMETERS (Required):
;;    FILENAME: String name of unformated binary file to read in. If a
;;    string array is passed, only the first entry is read.
;;
;;    DIM: Dimensions of unformatted data. Must be an integer or
;;    integer array with eight (8) or fewer values.
;;
;;KEYWORDS (Optional):
;;    ENDIAN: Binary flag to swap endian-ness (binary direction).
;;
;;EXAMPLE CALL:
;;    im = load_speckle_im, 'speckle.000.final', [1004,1002]
;-

  IF n_params() ne 2 THEN BEGIN ;Check if filename and dim are passed
     print,'load_speckle_im FAILURE: filename and data dimensions must be provided'
     return,0
  ENDIF
  
  IF size(filename,/type) ne 7 THEN BEGIN ;Check if file is a string
     print, 'load_speckle_im FAILURE: filename must be a string'
     return,0
  ENDIF

  s = size(dim)                      ;Check that dim is acceptable
  IF s[-1] gt 8 THEN BEGIN           ;Ensure dim doesn't ask for more than 8 dimensions
     print, 'load_speckle_im FAILURE: dim must have eight (8) or fewer entries'
     print, "    IDL can't make nine (9) dimensional arrays"
     return,0
  ENDIF
  IF s[-2] ne 2 THEN BEGIN      ;Ensure dim is integers
     print, 'load_speckle_im FAILURE: dim must be of type integer'
     return,0
  ENDIF

  ;;Read in unformated binary file
  dat = fltarr(dim)
  openr,lun,filename[0],/get_lun
  readu,lun,dat
  close,lun
  
  ;;Swap endian-ness if /endian is set
  IF keyword_set(endian) THEN dat = swap_endian(dat)

  return, dat
end
