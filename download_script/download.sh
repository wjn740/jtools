#wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.shortlog,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state" --accept-regex=ix64ph105 http://147.2.207.30/Results/ProductTests/SLES-12-SP1/beta2/x86_64/
wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start" --accept-regex=ix64ph105 http://147.2.207.30/Results/ProductTests/SLES-12-SP1/beta2/xen0-x86_64/
wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start" --accept-regex=ph022 http://147.2.207.30/Results/ProductTests/SLES-12-SP1/beta2/xen0-x86_64/
#wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.shortlog,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start" --accept-regex=ix64ph105 http://147.2.207.30/Results/ProductTests/SLES-12-SP0/GM/x86_64/
wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start" --accept-regex=ix64ph105 http://147.2.207.30/Results/ProductTests/SLES-12-SP0/GM/xen0-x86_64/
wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start" --accept-regex=ph022 http://147.2.207.30/Results/ProductTests/SLES-12-SP0/GM/xen0-x86_64/
wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start" --accept-regex=ph031 http://147.2.207.30/Results/ProductTests/SLES-12-SP0/GM/xen0-x86_64/
wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*,messages.syslog,rpmlist,hwinfo,kernel,environment,done,timer_state,test_results,process_state,netserver-start" --accept-regex=ph031 http://147.2.207.30/Results/ProductTests/SLES-12-SP1/beta2/xen0-x86_64/
