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
#Iges Linux Staging
############################################
LNX_STAGE_DIR=${STAGE_BASE_DIR}/Iges/lnx64/TranslatorBinaries/
LNX_SOURCE_PATH=${UNIT_PATH}/lnx64/kits/jt_iges_d
Iges_LNX_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Iges/lnx64
Iges_LNX_STAGE_DIR=${LNX_STAGE_DIR}jt_iges_d

if [ ! -d ${LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${LNX_STAGE_DIR}"
	mkdir -p ${LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${LNX_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Iges_LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${Iges_LNX_STAGE_DIR}"
	mkdir -p ${Iges_LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Iges_LNX_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${LNX_SOURCE_PATH}/*   ${Iges_LNX_STAGE_DIR} || { exit 1;}

RUN_LNX_IgesTOJT=${LNX_STAGE_DIR}/run_igestojt
RUN_LNX_IgesTOJT_MULTICAD=${LNX_STAGE_DIR}/run_igestojt_multicad

cp -f ${Iges_LNX_ARTIFACTS_DIR}/run_igestojt ${RUN_LNX_IgesTOJT} || { exit 1;}
cp -f ${Iges_LNX_ARTIFACTS_DIR}/run_igestojt_multicad ${RUN_LNX_IgesTOJT_MULTICAD} || { exit 1;}
cp -f ${Iges_LNX_ARTIFACTS_DIR}/IGESJT_Translator_README.txt ${STAGE_BASE_DIR}/Iges/lnx64/ || { exit 1;}

chmod 0755 ${RUN_LNX_IgesTOJT} || { exit 1;}
chmod 0755 ${RUN_LNX_IgesTOJT_MULTICAD} || { exit 1;}

############################################
#Iges Windows Staging
############################################
WNT_STAGE_DIR=${STAGE_BASE_DIR}/Iges/wntx64/TranslatorBinaries/
WNT_SOURCE_PATH=${UNIT_PATH}/wntx64/kits/jt_iges_d
Iges_WNT_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Iges/wntx64
Iges_WNT_STAGE_DIR=${WNT_STAGE_DIR}jt_iges_d

if [ ! -d ${WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${WNT_STAGE_DIR}"
	mkdir -p ${WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${WNT_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Iges_WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${Iges_WNT_STAGE_DIR}"
	mkdir -p ${Iges_WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Iges_WNT_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${WNT_SOURCE_PATH}/*   ${Iges_WNT_STAGE_DIR} || { exit 1;}

RUN_WNT_IgesTOJT=${WNT_STAGE_DIR}/run_igestojt.bat
RUN_WNT_IgesTOJT_MULTICAD=${WNT_STAGE_DIR}/run_igestojt_multicad.bat

cp -f ${Iges_WNT_ARTIFACTS_DIR}/run_igestojt.bat ${RUN_WNT_IgesTOJT} || { exit 1;}
cp -f ${Iges_WNT_ARTIFACTS_DIR}/run_igestojt_multicad.bat ${RUN_WNT_IgesTOJT_MULTICAD} || { exit 1;}
cp -f ${Iges_WNT_ARTIFACTS_DIR}/IGESJT_Translator_README.txt ${STAGE_BASE_DIR}/Iges/wntx64/ || { exit 1;}

chmod 0755 ${RUN_WNT_IgesTOJT} || { exit 1;}
chmod 0755 ${RUN_WNT_IgesTOJT_MULTICAD} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	############################################
	#Iges Linux Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Iges Linux build..."
	releaseLNXName="IgesJT_LINUX"
	cd ${STAGE_BASE_DIR}/Iges/lnx64 || { exit 1;}
	tar -czf $releaseLNXName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseLNXName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseLNXName/">deployStep.txt
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseLNXName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseLNXName/">>deployStep.txt
	cd -
	
	############################################
	#Iges Windows Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Iges Windows build..."
	releaseWNTName="IgesJT_WNT"
	cd ${STAGE_BASE_DIR}/Iges/wntx64 || { exit 1;}
	tar -czf $releaseWNTName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseWNTName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseWNTName/">deployStep.txt
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseWNTName/ || { exit 1;}"
	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/IGES/$releaseWNTName/">>deployStep.txt
	cd -
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
