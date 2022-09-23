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
#Inventor Linux Staging
############################################
LNX_STAGE_DIR=${STAGE_BASE_DIR}/Inventor/lnx64/TranslatorBinaries/
LNX_SOURCE_PATH=${UNIT_PATH}/lnx64/kits/jt_inventor
Inventor_LNX_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Inventor/lnx64
Inventor_LNX_STAGE_DIR=${LNX_STAGE_DIR}jt_inventor

if [ ! -d ${LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${LNX_STAGE_DIR}"
	mkdir -p ${LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${LNX_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Inventor_LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${Inventor_LNX_STAGE_DIR}"
	mkdir -p ${Inventor_LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Inventor_LNX_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${LNX_SOURCE_PATH}/*   ${Inventor_LNX_STAGE_DIR} || { exit 1;}

RUN_LNX_INVENTORTOJT=${LNX_STAGE_DIR}/run_inventortojt
RUN_LNX_INVENTORTOJT_MULTICAD=${LNX_STAGE_DIR}/run_inventortojt_multicad

cp -f ${Inventor_LNX_ARTIFACTS_DIR}/run_inventortojt ${RUN_LNX_INVENTORTOJT} || { exit 1;}
cp -f ${Inventor_LNX_ARTIFACTS_DIR}/run_inventortojt_multicad ${RUN_LNX_INVENTORTOJT_MULTICAD} || { exit 1;}
cp -f ${Inventor_LNX_ARTIFACTS_DIR}/InventorJT_Translator_README.txt ${STAGE_BASE_DIR}/Inventor/lnx64/ || { exit 1;}

chmod 0755 ${RUN_LNX_INVENTORTOJT} || { exit 1;}
chmod 0755 ${RUN_LNX_INVENTORTOJT_MULTICAD} || { exit 1;}

############################################
#Inventor Windows Staging
############################################
WNT_STAGE_DIR=${STAGE_BASE_DIR}/Inventor/wntx64/TranslatorBinaries/
WNT_SOURCE_PATH=${UNIT_PATH}/wntx64/kits/jt_inventor
Inventor_WNT_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/Inventor/wntx64
Inventor_WNT_STAGE_DIR=${WNT_STAGE_DIR}jt_inventor

if [ ! -d ${WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${WNT_STAGE_DIR}"
	mkdir -p ${WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${WNT_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Inventor_WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${Inventor_WNT_STAGE_DIR}"
	mkdir -p ${Inventor_WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Inventor_WNT_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${WNT_SOURCE_PATH}/*   ${Inventor_WNT_STAGE_DIR} || { exit 1;}

RUN_WNT_INVENTORTOJT=${WNT_STAGE_DIR}/run_Inventortojt.bat
RUN_WNT_INVENTORTOJT_MULTICAD=${WNT_STAGE_DIR}/run_Inventortojt_multicad.bat

cp -f ${Inventor_WNT_ARTIFACTS_DIR}/run_Inventortojt.bat ${RUN_WNT_INVENTORTOJT} || { exit 1;}
cp -f ${Inventor_WNT_ARTIFACTS_DIR}/run_Inventortojt_multicad.bat ${RUN_WNT_INVENTORTOJT_MULTICAD} || { exit 1;}
cp -f ${Inventor_WNT_ARTIFACTS_DIR}/InventorJT_Translator_README.txt ${STAGE_BASE_DIR}/Inventor/wntx64/ || { exit 1;}

chmod 0755 ${RUN_WNT_INVENTORTOJT} || { exit 1;}
chmod 0755 ${RUN_WNT_INVENTORTOJT_MULTICAD} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	############################################
	#Inventor Linux Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Inventor Linux build..."
	releaseLNXName="INVENTORJT_LINUX"
	cd ${STAGE_BASE_DIR}/Inventor/lnx64 || { exit 1;}
	tar -czf $releaseLNXName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/Inventor/$releaseLNXName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/Inventor/$releaseLNXName/ || { exit 1;}"
	cd -
	
	############################################
	#Inventor Windows Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for Inventor Windows build..."
	releaseWNTName="INVENTORJT_WNT"
	cd ${STAGE_BASE_DIR}/Inventor/wntx64 || { exit 1;}
	tar -czf $releaseWNTName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/Inventor/$releaseWNTName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/Inventor/$releaseWNTName/ || { exit 1;}"
	cd -
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
