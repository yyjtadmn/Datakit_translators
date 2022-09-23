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
#CatiaV4 Linux Staging
############################################
LNX_STAGE_DIR=${STAGE_BASE_DIR}/CatiaV4/lnx64/TranslatorBinaries/
LNX_SOURCE_PATH=${UNIT_PATH}/lnx64/kits/jt_catiav4_d
Catiav4_LNX_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/CatiaV4/lnx64
Catiav4_LNX_STAGE_DIR=${LNX_STAGE_DIR}jt_catiav4_d

if [ ! -d ${LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${LNX_STAGE_DIR}"
	mkdir -p ${LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${LNX_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Catiav4_LNX_STAGE_DIR} ]
then
	echo "Creating staging directory ${Catiav4_LNX_STAGE_DIR}"
	mkdir -p ${Catiav4_LNX_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Catiav4_LNX_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${LNX_SOURCE_PATH}/*   ${Catiav4_LNX_STAGE_DIR} || { exit 1;}

RUN_LNX_Catiav4TOJT=${LNX_STAGE_DIR}/run_catiav4tojt
RUN_LNX_Catiav4TOJT_MULTICAD=${LNX_STAGE_DIR}/run_catiav4tojt_multicad

cp -f ${Catiav4_LNX_ARTIFACTS_DIR}/run_catiav4tojt ${RUN_LNX_Catiav4TOJT} || { exit 1;}
cp -f ${Catiav4_LNX_ARTIFACTS_DIR}/run_catiav4tojt_multicad ${RUN_LNX_Catiav4TOJT_MULTICAD} || { exit 1;}
cp -f ${Catiav4_LNX_ARTIFACTS_DIR}/CatiaV4JT_Translator_README.txt ${STAGE_BASE_DIR}/CatiaV4/lnx64/ || { exit 1;}

chmod 0755 ${RUN_LNX_Catiav4TOJT} || { exit 1;}
chmod 0755 ${RUN_LNX_Catiav4TOJT_MULTICAD} || { exit 1;}

############################################
#CatiaV4 Windows Staging
############################################
WNT_STAGE_DIR=${STAGE_BASE_DIR}/CatiaV4/wntx64/TranslatorBinaries/
WNT_SOURCE_PATH=${UNIT_PATH}/wntx64/kits/jt_catiav4_d
Catiav4_WNT_ARTIFACTS_DIR=${CUSTOMER_ARTIFACTS_DIR}/CatiaV4/wntx64
Catiav4_WNT_STAGE_DIR=${WNT_STAGE_DIR}jt_catiav4_d

if [ ! -d ${WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${WNT_STAGE_DIR}"
	mkdir -p ${WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${WNT_STAGE_DIR} || { exit 1;}
fi

if [ ! -d ${Catiav4_WNT_STAGE_DIR} ]
then
	echo "Creating staging directory ${Catiav4_WNT_STAGE_DIR}"
	mkdir -p ${Catiav4_WNT_STAGE_DIR} || { exit 1;}
	chmod -R 0777 ${Catiav4_WNT_STAGE_DIR} || { exit 1;}
fi

# Copy all 
cp -r ${WNT_SOURCE_PATH}/*   ${Catiav4_WNT_STAGE_DIR} || { exit 1;}

RUN_WNT_Catiav4TOJT=${WNT_STAGE_DIR}/run_catiav4tojt.bat
RUN_WNT_Catiav4TOJT_MULTICAD=${WNT_STAGE_DIR}/run_catiav4tojt_multicad.bat

cp -f ${Catiav4_WNT_ARTIFACTS_DIR}/run_catiav4tojt.bat ${RUN_WNT_Catiav4TOJT} || { exit 1;}
cp -f ${Catiav4_WNT_ARTIFACTS_DIR}/run_catiav4tojt_multicad.bat ${RUN_WNT_Catiav4TOJT_MULTICAD} || { exit 1;}
#cp -f ${Catiav4_WNT_ARTIFACTS_DIR}/CatiaV4JT_Translator_README.txt ${STAGE_BASE_DIR}/CatiaV4/wntx64/ || { exit 1;}

chmod 0755 ${RUN_WNT_Catiav4TOJT} || { exit 1;}
chmod 0755 ${RUN_WNT_Catiav4TOJT_MULTICAD} || { exit 1;}

if [ ${EXECUTE_DEPLOY} == "true" ]
then
	############################################
	#CatiaV4 Linux Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for CatiaV4 Linux build..."
	releaseLNXName="Catiav4JT_LINUX"
	cd ${STAGE_BASE_DIR}/CatiaV4/lnx64 || { exit 1;}
	tar -czf $releaseLNXName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseLNXName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CatiaV4/$releaseLNXName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CatiaV4/$releaseLNXName/ || { exit 1;}"
	cd -
	
	############################################
	#CatiaV4 Windows Deploy
	############################################
	echo "Deploy flag is set to true. Executing deploy step for CatiaV4 Windows build..."
	releaseWNTName="Catiav4JT_WNT"
	cd ${STAGE_BASE_DIR}/CatiaV4/wntx64 || { exit 1;}
	tar -czf $releaseWNTName.tar.gz TranslatorBinaries/ || { exit 1;}
	
	echo "curl -u opentools_bot:YL6MtwZ35 -T $releaseWNTName.tar.gz https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CatiaV4/$releaseWNTName/ || { exit 1;}"

	echo "curl -u opentools_bot:YL6MtwZ35 -T NXJT_Translator_README.txt https://artifacts.industrysoftware.automation.siemens.com/artifactory/generic-local/Opentools/PREVIEW/CatiaV4/$releaseWNTName/ || { exit 1;}"
	cd -
else
	echo "Deploy flag is set to false. Skipping deploy step..."
fi
