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
#Acis Linux Staging
############################################
LNX_STAGE_DIR=${STAGE_BASE_DIR}/Acis/lnx64/TranslatorBinaries/
LNX_SOURCE_PATH=${UNIT_PATH}/lnx64/kits/jt_acis
Acis_LNX_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Acis/lnx64
Acis_LNX_STAGE_DIR=${LNX_STAGE_DIR}jt_acis

if [ ! -d ${LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${LNX_STAGE_DIR}"
	mkdir -p ${LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${LNX_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Acis_LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${Acis_LNX_STAGE_DIR}"
	mkdir -p ${Acis_LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Acis_LNX_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${LNX_SOURCE_PATH}/*   ${Acis_LNX_STAGE_DIR} || { exit 1;}

RUN_LNX_AcisTOJT=${LNX_STAGE_DIR}/run_acistojt
RUN_LNX_AcisTOJT_MULTICAD=${LNX_STAGE_DIR}/run_acistojt_multicad

cp -f ${Acis_LNX_ARTIFACTS_DIR}/run_acistojt ${RUN_LNX_AcisTOJT} || { exit 1;}
cp -f ${Acis_LNX_ARTIFACTS_DIR}/run_acistojt_multicad ${RUN_LNX_AcisTOJT_MULTICAD} || { exit 1;}
cp -f ${Acis_LNX_ARTIFACTS_DIR}/AcisJT_Translator_README.txt ${STAGE_BASE_DIR}/Acis/lnx64/ || { exit 1;}

chmod 0755 ${RUN_LNX_AcisTOJT} || { exit 1;}
chmod 0755 ${RUN_LNX_AcisTOJT_MULTICAD} || { exit 1;}

############################################
#Acis Windows Staging
############################################
WNT_STAGE_DIR=${STAGE_BASE_DIR}/Acis/wntx64/TranslatorBinaries/
WNT_SOURCE_PATH=${UNIT_PATH}/wntx64/kits/jt_acis
Acis_WNT_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Acis/wntx64
Acis_WNT_STAGE_DIR=${WNT_STAGE_DIR}jt_acis

if [ ! -d ${WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${WNT_STAGE_DIR}"
	mkdir -p ${WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${WNT_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Acis_WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${Acis_WNT_STAGE_DIR}"
	mkdir -p ${Acis_WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Acis_WNT_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${WNT_SOURCE_PATH}/*   ${Acis_WNT_STAGE_DIR} || { exit 1;}

RUN_WNT_AcisTOJT=${WNT_STAGE_DIR}/run_acistojt.bat
RUN_WNT_AcisTOJT_MULTICAD=${WNT_STAGE_DIR}/run_acistojt_multicad.bat

cp -f ${Acis_WNT_ARTIFACTS_DIR}/run_acistojt.bat ${RUN_WNT_AcisTOJT} || { exit 1;}
cp -f ${Acis_WNT_ARTIFACTS_DIR}/run_acistojt_multicad.bat ${RUN_WNT_AcisTOJT_MULTICAD} || { exit 1;}
cp -f ${Acis_WNT_ARTIFACTS_DIR}/AcisJT_Translator_README.txt ${STAGE_BASE_DIR}/Acis/wntx64/ || { exit 1;}

chmod 0755 ${RUN_WNT_AcisTOJT} || { exit 1;}
chmod 0755 ${RUN_WNT_AcisTOJT_MULTICAD} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	############################################
	#Acis Linux Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Acis Linux build..."
	releaseLNXName="AcisJT_LINUX"
	cd ${STAGE_BASE_DIR}/Acis/lnx64 || { exit 1;}
	tar -czf $releaseLNXName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/ACIS/$releaseLNXName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/ACIS/$releaseLNXName/ || { exit 1;}"
	cd -
	
	############################################
	#Acis Windows Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Acis Windows build..."
	releaseWNTName="AcisJT_WNT"
	cd ${STAGE_BASE_DIR}/Acis/wntx64 || { exit 1;}
	tar -czf $releaseWNTName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/ACIS/$releaseWNTName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/ACIS/$releaseWNTName/ || { exit 1;}"
	cd -
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
