set diskname test.dsk

# create disk
diskmanipulator create $diskname 360k

# load disk
virtual_drive $diskname

# import file(s)
diskmanipulator import virtual_drive autoexec.bas

# byee~
exit
