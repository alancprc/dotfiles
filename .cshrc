#! /bin/csh
# 
# cshrc_template - This file may be copied into your ~/ directory and
# renamed to '.cshrc'.  
# 
#
########################################################################
#
# Revision History:
#
#  99-10-07     bji          Removed set DISPLAY
#  98-12-23     dc           Changed to use get_revision
#  98-10-19     dc           Changes for LTXHOME, set DISPLAY
#  96-03-21     srf          Fixed Device Tool entries.
#  95-12-18     swt/sherryl  Created. (cloned from kshrc_template)
#
########################################################################

if ( $?DEBUG_ON == 1 ) set echo

umask 002   # Set protections on created files.

# HOST_OS contains system OS type.
set HOST_OS = ( InvalidHostOS )
if ( -f /usr/bin/uname    ) set HOST_OS = ( `/usr/bin/uname` )   
if ( -f /bin/uname        ) set HOST_OS = ( `/bin/uname` )       
if ( -f /sys5.3/bin/uname ) set HOST_OS = ( `/sys5.3/bin/uname` )

# set ltx PATH components :
if ( -f /opt/ltx/bin/get_revision ) then
    set which_ltx = `/opt/ltx/bin/get_revision`
else if ( $?LTXHOME ) then
    set which_ltx = $LTXHOME
else
    set which_ltx = "/ltx"
endif

if ( -e $HOME/.user_cshrc ) then
   source $HOME/.user_cshrc
endif

if ( $HOST_OS == "Linux" ) then
    setenv PATH  ".:/bin:/usr/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin:/usr/local/Adobe/Acrobat7.0/bin:/opt/totalview/bin:/opt/ltx/bin:${which_ltx}/com:${which_ltx}/bin:${which_ltx}/cmd:${which_ltx}/scripts:${which_ltx}/service:${PATH}"
    setenv MANPATH /usr/man:/usr/local/man:/usr/share/man:/usr/X11R6/man
else if ( $HOST_OS == "SunOS" ) then 
    # This path is written to give SYS V commands precedence over BSD equivalents.
    setenv PATH .:~/com:/usr/ccs/bin:/usr/bin:/usr/ucb:/bin:/etc:/usr/vue/bin:/opt/softbench/bin:/usr/local/bin:/usr/bin/X11:/usr/openwin/bin:/usr/openwin/bin/xview:/usr/openwin/lib:/usr/openwin/share:/opt/ltx/bin:${which_ltx}/com:${which_ltx}/cmd
    setenv MANPATH /usr/man:/usr/local/man:/usr/snm/man:/usr/openwin/man:/usr/vue/man
endif

set history = 7500                 # Increase history length.

# Device tool variables:
#setenv SDA_LOG_DIRECTORY "~/cdslogs"
#setenv CDS_NUM_USER_COLORS "48"
# Replace /cds with the actual install path of the Cadence Design Systems software.
#setenv CDS_INSTALL_PATH "/cds"
#setenv MANPATH "${MANPATH}:${CDS_INSTALL_PATH}/tools/dfII/man"
#setenv opusPath "${CDS_INSTALL_PATH}/tools/bin:${CDS_INSTALL_PATH}/tools/dfII/bin"
#setenv path "$PATH:$opusPath"

# General variables:
setenv EDITOR emacs
setenv CDPATH ".:~:${which_ltx}:/user"

# This variable is needed for X application resource files.
# NOTE: XUSERFILESEARCHPATH is preferred over XAPPLRESDIR in X11R4+
setenv XUSERFILESEARCHPATH ~/app-defaults/%N 

# Change 'blah' to a file name in /ltx/printers.  This will be the
# default printer for the ltx tools.
#setenv LTX_PRINTER blah

# Setting the LTX_UICPATH variable to a particular path will make all 
# tools search that path for their configuration files
#setenv LTX_UICPATH .:~/:${which_ltx}/site:${which_ltx}/defaults

alias   h  history       # Shortcut for history listing
alias   rm 'rm -i'       # Better safe than sorry

# This is creating an alias in the environment for every file in
# /usr/dmd/current/system/bin to first source
# /usr/dmd/current/setup/runtime_env.csh then run the executable in a separate
# csh process so that the setting of LD_LIBRARY_PATH gets set correctly to
# execute any legacy Diamonds executables.  The separate csh process is needed
# so that the enironment does not get tainted with legacy Diamond settings and
# thus breaking Unison execuatbles. This is sspecially important for things like
# Qt which uses different versions between Unison and legacy Diamond.

if ( -d /usr/dmd/current/system/bin ) then
  ls -1 /usr/dmd/current/system/bin/. | awk '{ printf("alias %s \047csh -c \"(source /usr/dmd/current/setup/runtime_env.csh ; /usr/dmd/current/system/bin/%s)\"\047\n",$1,$1); }' > /tmp/$$.cshrc
  source /tmp/$$.cshrc
  rm -rf /tmp/$$.cshrc >& /dev/null
endif


# set prompt = '[\!]% '
set prompt = "`whoami`@`hostname`> "

if (! $?LD_LIBRARY_PATH) then
	setenv LD_LIBRARY_PATH /lib:/usr/lib:/usr/X11R6/lib:/usr/local/lib
endif


# alias set_revision 'setenv chosen_ltx  \!*; source /opt/ltx/bin/set_revision.csh'
# allows the user to set LTXHOME in the current shell by typing
#    set_revision <path>
setenv XLM_ENABLE_LM_LICENSE_FILE 1

# Required for unison 
setenv LM_LICENSE_FILE /opt/LTXflexnet/license.dat:/usr/local/flexlm/licenses/cmos_vld.lic

if ( -e ~/.cshrc.custom ) then
    source ~/.cshrc.custom
endif
