//genesis

//*****************************************************************************
//... es lon a kornek kerulete
float	PI		=	3.14159

//*****************************************************************************
//integralasi idok adjusztalasa

//*****************************************************************************
//Az egyszeruseg es elegancia kedveert:
int	EXPONENTIAL	=	1
int	SIGMOID		=	2
int	LINOID		=	3

//*****************************************************************************
///Remelheto, hogy ekkora egy sejt ...
float	SOMA_D_MSGABA	=	20.0e-6				// m
float	SOMA_L_MSGABA	=	20.0e-6				// m
float	SOMA_A_MSGABA	=	PI * SOMA_D_MSGABA * SOMA_L_MSGABA	// m^2
float	SOMA_XA_MSGABA	=	PI * SOMA_D_MSGABA * SOMA_D_MSGABA / 4	// m^2

//*****************************************************************************
//Tovabbi szukseges konstansok
//MEMBRANE PARAMETERS
float	RM_MSGABA		=	1		// ohm*m^2
float	RA_MSGABA		=	0.3		// ohm-m
float	CM_MSGABA		=	0.01		// F/m^2
float	EREST_ACT_MSGABA	=	-65e-3		// V
float	ELEAK_MSGABA		=	-.05		// V
float	EK_MSGABA		=	-.085		// V
float	ENA_MSGABA		=	.055		// V

//*****************************************************************************
//A tablazatokhoz
float	VRES		=	3200
float	VMIN		=	-0.100		// V
float	VMAX		=	0.110		// V

//*****************************************************************************
//A misztikus PHI parameter
float	Phi		=	5

//Szinapszis kuszob fesz.
float Theta_m2m = 0
float Theta_GABA = 0
float Theta_o2m = 0

//time variables
float	tmax		=	1.5
