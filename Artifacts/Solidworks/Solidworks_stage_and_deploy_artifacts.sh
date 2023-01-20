#!/bin/bash

if [ $# -ne 4 ]
then
        echo "stage_and_deploy_artifacts.sh called with incorrect number of arguments."
        echo "stage_and_deploy_artifacts.sh <unitPaht> <StageBaseDir> <CustomerArtifactDir> <DeployFlag>"
        echo "For example; stage_and_deploy_artifacts.sh /plm/pnnas/ppic/users/<unit_name> /plm/pnnas/ppic/users/<stage_dir> <Artifacts> true/false"
        exit 1
fi

echo "Executing stage_and_deploy_artifacts.sh..."

UNIT_PATH=$1
STAGE_BASE_DIR=$2
CUSTOMER_ARTIFACTS_DIR=$3
EXECUTE_DEPLOY=$4

############################################
#Solidworks Linux Staging
############################################
LNX_STAGE_DIR=${STAGE_BASE_DIR}/Solidworks/lnx64/TranslatorBinaries/
LNX_SOURCE_PATH=${UNIT_PATH}/lnx64/kits/jt_sw
SOLIDWORKS_LNX_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Solidworks/lnx64
SOLIDWORKS_LNX_STAGE_DIR=${LNX_STAGE_DIR}jt_sw

if [ ! -d ${LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${LNX_STAGE_DIR}"
	mkdir -p ${LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${LNX_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${SOLIDWORKS_LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${SOLIDWORKS_LNX_STAGE_DIR}"
	mkdir -p ${SOLIDWORKS_LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${SOLIDWORKS_LNX_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${LNX_SOURCE_PATH}/*   ${SOLIDWORKS_LNX_STAGE_DIR} || { exit 1;}

RUN_LNX_SWTOJT=${LNX_STAGE_DIR}/run_swtojt
RUN_LNX_SWTOJT_MULTICAD=${LNX_STAGE_DIR}/run_swtojt_multicad

cp -f ${SOLIDWORKS_LNX_ARTIFACTS_DIR}/run_swtojt ${RUN_LNX_SWTOJT} || { exit 1;}
cp -f ${SOLIDWORKS_LNX_ARTIFACTS_DIR}/run_swtojt_multicad ${RUN_LNX_SWTOJT_MULTICAD} || { exit 1;}
cp -f ${SOLIDWORKS_LNX_ARTIFACTS_DIR}/SWJT_Translator_README.txt ${STAGE_BASE_DIR}/Solidworks/lnx64/ || { exit 1;}

chmod 0755 ${RUN_LNX_SWTOJT} || { exit 1;}
chmod 0755 ${RUN_LNX_SWTOJT_MULTICAD} || { exit 1;}

############################################
#Solidworks Windows Staging
############################################
WNT_STAGE_DIR=${STAGE_BASE_DIR}/Solidworks/wntx64/TranslatorBinaries/
WNT_SOURCE_PATH=${UNIT_PATH}/wntx64/kits/jt_sw
SOLIDWORKS_WNT_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Solidworks/wntx64
SOLIDWORKS_WNT_STAGE_DIR=${WNT_STAGE_DIR}jt_sw

if [ ! -d ${WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${WNT_STAGE_DIR}"
	mkdir -p ${WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${WNT_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${SOLIDWORKS_WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${SOLIDWORKS_WNT_STAGE_DIR}"
	mkdir -p ${SOLIDWORKS_WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${SOLIDWORKS_WNT_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${WNT_SOURCE_PATH}/*   ${SOLIDWORKS_WNT_STAGE_DIR} || { exit 1;}

RUN_WNT_SWTOJT=${WNT_STAGE_DIR}/run_swtojt.bat
RUN_WNT_SWTOJT_MULTICAD=${WNT_STAGE_DIR}/run_swtojt_multicad.bat

cp -f ${SOLIDWORKS_WNT_ARTIFACTS_DIR}/run_swtojt.bat ${RUN_WNT_SWTOJT} || { exit 1;}
cp -f ${SOLIDWORKS_WNT_ARTIFACTS_DIR}/run_swtojt_multicad.bat ${RUN_WNT_SWTOJT_MULTICAD} || { exit 1;}
cp -f ${SOLIDWORKS_WNT_ARTIFACTS_DIR}/SWJT_Translator_README.txt ${STAGE_BASE_DIR}/Solidworks/wntx64/ || { exit 1;}

chmod 0755 ${RUN_WNT_SWTOJT} || { exit 1;}
chmod 0755 ${RUN_WNT_SWTOJT_MULTICAD} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	############################################
	#Solidworks Linux Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for solidworks Linux build..."
	releaseLNXName="SWJT_LINUX"
	cd ${STAGE_BASE_DIR}/Solidworks/lnx64 || { exit 1;}
	tar -czf $releaseLNXName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseLNXName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseLNXName/">deployStep.txt
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseLNXName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseLNXName/">>deployStep.txt
	cd -
	
	############################################
	#Solidworks Windows Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for solidworks Windows build..."
	releaseWNTName="SWJT_WNT"
	cd ${STAGE_BASE_DIR}/Solidworks/wntx64 || { exit 1;}
	tar -czf $releaseWNTName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseWNTName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseWNTName/">deployStep.txt
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseWNTName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/SOLIDWORKS/$releaseWNTName/">>deployStep.txt
	cd -
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
