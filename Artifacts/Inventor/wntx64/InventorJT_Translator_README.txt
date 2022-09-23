Inventor to JT Translator - v1.0.0 Beta Release version
Release Date {July 08, 2022}
======================================================================================================================

SECTION 1 - Release Information

SECTION 2 - Capabilities Supported

SECTION 3 - Platforms and OS Supported

SECTION 4 - Installation Instructions and Usage

SECTION 5 - Known issues and limitations

SECTION 6 - Licensing

SECTION 7 - Technical Support

----------------------------------------------------------------------------------------------------------------------

SECTION 1 - Release Information

The translator package includes v1.0.0 beta of the Inventor JT translator.
This supports translation of Inventor (*.iam, *.ipt) files.

The translator is invoked through a Linux console.
You can provide a single Inventor file that may be a piece part or an assembly as input and get one JT file as output.

The command line options are as follows
	-o <output_dir>
	-z <config_file>
	-single_part
 
----------------------------------------------------------------------------------------------------------------------

SECTION 2 - Capabilities Supported

    - The Inventor JT translator supports following capabilities
		1. Geometry – Solids, Surfaces (NURBS & analytical)
		2. Assembly – Structure, Transforms, Multiple instances, Mirror components, Mixed unit assembly
		3. Style – Solid and Surface body colors
		5. Model units
		6. Log reporting

----------------------------------------------------------------------------------------------------------------------

SECTION 3 - Platforms and OS Supported

LINUX:
	- CentOS Linux release 7.6.1810 (Core)
	
Windows
	- Windows 10 x64.
----------------------------------------------------------------------------------------------------------------------

SECTION 4 - Installation Instructions and Usage

 	- Following Linux packages are prerequisites to run translator binaries -
			fontconfig 
			ksh
			  
	- Set following environment variables -
			INVENTOR_JT_INSTALL=.../jt_inventor                ---> This is the directory containing translator binaries.
			LANG=en_US.utf8                              ---> Use any UTF8 locale to enable internationalization.
		
	- Sample docker file 
			FROM centos:7
			RUN yum update --assumeyes --skip-broken && yum install --assumeyes fontconfig ksh && yum clean all
			WORKDIR /app
			COPY jt_inventor/     /app/jt_inventor
			COPY run_creotojt /app

			ENV INVENTOR_JT_INSTALL=/app/jt_inventor
			ENV LANG=en_US.utf8
		
	- Run script "run_creotojt" with part or assembly file as input.
	    	run_creotojt <xxx.ipt>
	
	un script "run_creotojt_multicad" with part or assembly file as input to create JT files containing tesellation and XT BREP. 
	    	run_creotojt_multicad <xxx.ipt>

	- If you need to specify an output directory for the jt files the following command line option can be used
		-o <output_dir>
	
----------------------------------------------------------------------------------------------------------------------
SECTION 5 - Known issues and limitations
 
    - Following capabilities are currently not supported
	    1. Mesh bodies
	    2. Wireframes and Work geometry
	    3. Assembly and Part configurations 
	    4. PMI/Annotations
	    5. Model views and View-specific visibility
	    6. Hidden bodies and surfaces are translated.
	
----------------------------------------------------------------------------------------------------------------------
SECTION 6 - Licensing

    - This build of the translator is set to stop working on February 1st 2023. 

----------------------------------------------------------------------------------------------------------------------
SECTION 7 - Technical Support
 
	- Please contact Open Tools Translator Products development if you have any queries or issues
	  about translator configuration and usage.

----------------------------------------------------------------------------------------------------------------------