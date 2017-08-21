#include<iostream>
#include<cmath>
#include<fstream>
#include<iomanip>
using namespace std;

int main(){
  ofstream data_output,plot_output;
  double P1, Pc,Pd,dP, Lad, Lin,P_char,T_char,Tc,P_bottom,P_top,den_top,z_top;
  double R , z , den1 , grav , T1, Td, z0;
  double exp1, exp2,exp3,sig_factor,dP_factor;
  double X = 1.0;  
  double P2, dz, den2, T2;
  int alpha=1, beta=0, count = 0;
 
 
  //Declaration Block
  Td = 100.0;   //T_deep : the temperature at the top of the atmosphere[K]
 // Pc = 1.0e9;    //the pressure at the convective-radiation boundary [10^-6 bar]
  P_char = 1.0e6;
  T_char = 250.0;
  dP = 1.0e+3;
  Lad = (2.0/7.0); //the adiabatic index of an ideal diatomic gas
  Lin = (1.0/2.0);
  grav = -1.0e3;
  R = (1.38e-16)/(2.34*1.66e-24); 

  exp1=1 + alpha;
  exp2=(1.0/(4.0-beta));
  exp3=exp1/exp2;
//  P0 = 9.0e11;//1.0e11;
  
  den_top=5.0e-7 ;// the density limit at the top of the atmosphere
  P_top=den_top*R*Td ;//the pressure limit at the density limit
  
  z_top=1.0e5; //the size of the computation box
  Tc = Td * pow(Lin/(Lin-Lad),exp2);
  Pc = P_char * pow(Tc/T_char,1.0/Lad);
  Pd = pow((Lin-Lad)/(2.0*Lin-Lad),1.0/exp1)*Pc;
//  P0=pow(pow(Pd,Lad)-pow(Pc,Lad)*Lad/Tc*(Td*log(Pd/P_top)-2.0*(-grav)/R*z0),1.0/Lad);
  P_bottom=Pc*pow(1.0+Lad*(Td/Tc)*log(P_top/Pc)-2.0*Lad*grav*z_top/R/Tc,1.0/Lad);//the pressure at the top of the atmosphere
  sig_factor=0.001;
  P1=P_top;
  dP_factor=1.e6;
  //CHECK!!!!!: if z0>scale height, Td*R/(-grav)
  //Open data file
  data_output.open ("isothermal.hse",ios::out);
  plot_output.open ("isothermal_100.txt",ios::out);
  data_output << "# npts = 281465" << '\n' << "# num of variables = 4" << '\n' << "# density" << '\n' << "# temperature" <<'\n' << "# pressure" << '\n' << "# X " << '\n';
  z=z_top;
  P1=P_top;
  
  //Iterate over values until P>10^11 using constant dP
  do{
    dP=P1/dP_factor;
    P2 = P1+dP;
    
    
    T2 = Td;
    T1 = Td;
          
    
    den1 = (P1/(R*T1));
    den2 = (P2/(R*T2));

    z=( z_top +  Td*R/(grav)*log(P2/P_top));
    
    P1 = P2;
    
 
  }while(z>0.);
  
  
  
  do{
    dP=P1/dP_factor;
    P2 = P1-dP;
    
  
    T2 = Td;
    T1 = Td;
    
    den1 = (P1/(R*T1));
    den2 = (P2/(R*T2));
    
    z=( z_top +  Td*R/(grav)*log(P2/P_top));
    if(z>=0.){
      data_output << setprecision(10) << z << ' ' << den1 << ' ' << T1 << ' ' << P1 << ' '<<  X << '\n';
      
      plot_output << setprecision(10) << z/1e5 << ' ' << ' ' << den1 << ' '<< ' ' << T1 << ' ' << ' '<< P1/1.0e6 << ' ' << ' '<<  X << '\n';
      count++;
    }
    
    // z = z - dz;
    P1 = P2;
    cout << count  << ' ' << "density[g/cm^3]="<< ' '<< den1 << ' '<<' '<<"height[km]="<< ' '<<' '<< z/1.0e5 << "P[dyne/cm^2]="<< ' '<<' '<< P1/1.0e6 << "T[K]="<< ' '<<' '<< T1 << '\n' ;
    
  
  
  }while(z<=z_top);
  
  
  
  //Close data file
  data_output.close();
  plot_output.close();
  return 0;
}
