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
#Creo Linux Staging
############################################
LNX_STAGE_DIR=${STAGE_BASE_DIR}/Creo/lnx64/TranslatorBinaries/
LNX_SOURCE_PATH=${UNIT_PATH}/lnx64/kits/jt_creo_d
Creo_LNX_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Creo/lnx64
Creo_LNX_STAGE_DIR=${LNX_STAGE_DIR}jt_creo_d

if [ ! -d ${LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${LNX_STAGE_DIR}"
	mkdir -p ${LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${LNX_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Creo_LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${Creo_LNX_STAGE_DIR}"
	mkdir -p ${Creo_LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Creo_LNX_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${LNX_SOURCE_PATH}/*   ${Creo_LNX_STAGE_DIR} || { exit 1;}

RUN_LNX_CreoTOJT=${LNX_STAGE_DIR}/run_creotojt
RUN_LNX_CreoTOJT_MULTICAD=${LNX_STAGE_DIR}/run_creotojt_multicad

cp -f ${Creo_LNX_ARTIFACTS_DIR}/run_creotojt ${RUN_LNX_CreoTOJT} || { exit 1;}
cp -f ${Creo_LNX_ARTIFACTS_DIR}/run_creotojt_multicad ${RUN_LNX_CreoTOJT_MULTICAD} || { exit 1;}
cp -f ${Creo_LNX_ARTIFACTS_DIR}/CreoJT_Translator_README.txt ${STAGE_BASE_DIR}/Creo/lnx64/ || { exit 1;}

chmod 0755 ${RUN_LNX_CreoTOJT} || { exit 1;}
chmod 0755 ${RUN_LNX_CreoTOJT_MULTICAD} || { exit 1;}

############################################
#Creo Windows Staging
############################################
WNT_STAGE_DIR=${STAGE_BASE_DIR}/Creo/wntx64/TranslatorBinaries/
WNT_SOURCE_PATH=${UNIT_PATH}/wntx64/kits/jt_creo_d
Creo_WNT_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Creo/wntx64
Creo_WNT_STAGE_DIR=${WNT_STAGE_DIR}jt_creo_d

if [ ! -d ${WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${WNT_STAGE_DIR}"
	mkdir -p ${WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${WNT_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Creo_WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${Creo_WNT_STAGE_DIR}"
	mkdir -p ${Creo_WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Creo_WNT_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${WNT_SOURCE_PATH}/*   ${Creo_WNT_STAGE_DIR} || { exit 1;}

RUN_WNT_CreoTOJT=${WNT_STAGE_DIR}/run_Creotojt.bat
RUN_WNT_CreoTOJT_MULTICAD=${WNT_STAGE_DIR}/run_Creotojt_multicad.bat

cp -f ${Creo_WNT_ARTIFACTS_DIR}/run_Creotojt.bat ${RUN_WNT_CreoTOJT} || { exit 1;}
cp -f ${Creo_WNT_ARTIFACTS_DIR}/run_Creotojt_multicad.bat ${RUN_WNT_CreoTOJT_MULTICAD} || { exit 1;}
cp -f ${Creo_WNT_ARTIFACTS_DIR}/CreoJT_Translator_README.txt ${STAGE_BASE_DIR}/Creo/wntx64/ || { exit 1;}

chmod 0755 ${RUN_WNT_CreoTOJT} || { exit 1;}
chmod 0755 ${RUN_WNT_CreoTOJT_MULTICAD} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	############################################
	#Creo Linux Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Creo Linux build..."
	releaseLNXName="CreoJT_LINUX"
	cd ${STAGE_BASE_DIR}/Creo/lnx64 || { exit 1;}
	tar -czf $releaseLNXName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CREO/$releaseLNXName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CREO/$releaseLNXName/ || { exit 1;}"
	cd -
	
	############################################
	#Creo Windows Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Creo Windows build..."
	releaseWNTName="CreoJT_WNT"
	cd ${STAGE_BASE_DIR}/Creo/wntx64 || { exit 1;}
	tar -czf $releaseWNTName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CREO/$releaseWNTName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CREO/$releaseWNTName/ || { exit 1;}"
	cd -
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
