Acis to JT Translator - v1.0.0 Beta Release version
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

The translator package includes v1.0.0 beta of the Acis JT translator.
This supports translation of Acis (*.sat, *.sab) files.

The translator is invoked through a Linux console.
You can provide a single Acis file that may be a piece part or an assembly as input and get one JT file as output.

The command line options are as follows
	-o <outputir>
	-z <config_file>
	-single_part
 
----------------------------------------------------------------------------------------------------------------------

SECTION 2 - Capabilities Supported

    - The Acis JT translator supports following capabilities
		1. Geometry – Solids, Surfaces (NURBS & analytical),Wires 
		2. Construction geometry- Points
		3. Wireframe color, Solid/Sheet body color
		4. Units – MM & Inch parts
		5. Log reporting 

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
			ACIS_JT_INSTALL=.../jt_acis                ---> This is the directory containing translator binaries.
			LANG=en_US.utf8                              ---> Use any UTF8 locale to enable internationalization.
		
	- Sample docker file 
			FROM centos:7
			RUN yum update --assumeyes --skip-broken && yum install --assumeyes fontconfig ksh && yum clean all
			WORKDIR /app
			COPY jt_acis/     /app/jt_acis
			COPY run_acistojt /app

			ENV ACIS_JT_INSTALL=/app/jt_acis
			ENV LANG=en_US.utf8
		
	- Run script "run_acistojt" with acis file as input.
	    	run_acistojt <xxx.sat>
	
	un script "run_acistojt_multicad" with acis file as input to create JT files containing tesellation and XT BREP. 
	    	run_acistojt_multicad <xxx.sat>

	- If you need to specify an output directory for the jt files the following command line option can be used
		-o <outputir>
	
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