#include<iostream>
#include<cmath>
#include<fstream>
#include<iomanip>
//#include"cephes/hyp2f1.c"
using namespace std;

int main(){
  ofstream data_output,plot_output;
  double P1, Pc,Pd,dP, Lad, Lin,P_char,T_char,Tc,P_bottom,P_top,den_top,z_top;
  double R , z , den1 , grav , T1, Td, z0;
  double exp1, exp2,exp3,sig_factor,dP_factor;
  double X = 1.0;  
  double P2, dz, den2, T2,number_cell,crudeness_factor;
  int alpha=1, beta=0, count = 0;
  //std::cout.precision(20);
 
  //Declaration Block
  Td = 1500.0;   //T_deep : the temperature at the top of the atmosphere[K]
 // Pc = 1.0e9;    //the pressure at the convective-radiation boundary [10^-6 bar]
  P_char = 1.0e6;
  T_char = 250.0;
  dP = 1.0e+3;
  Lad = (2.0/7.0); //the adiabatic index of an ideal diatomic gas
  Lin = (1.0/2.0);
  grav = -1.0e3;
  R = (1.3806488e-16)/2.34*6.02214129e23;
  number_cell=256.0
  crudeness_factor=1.0
  exp1=1 + alpha;
  exp2=(1.0/(4.0-beta));
  exp3=exp1/exp2;
//  P0 = 9.0e11;//1.0e11;
  
  den_top=1.e-10 ;// the density limit at the top of the atmosphere
  P_top=den_top*R*Td ;//the pressure limit at the density limit
  
  z_top=1.0e8; //the size of the computation box
  Tc = Td * pow(Lin/(Lin-Lad),exp2);
  Pc = P_char * pow(Tc/T_char,1.0/Lad);
  Pd = pow((Lin-Lad)/(2.0*Lin-Lad),1.0/exp1)*Pc;
//  P0=pow(pow(Pd,Lad)-pow(Pc,Lad)*Lad/Tc*(Td*log(Pd/P_top)-2.0*(-grav)/R*z0),1.0/Lad);
  P_bottom=Pc*pow(1.0+Lad*(Td/Tc)*log(P_top/Pc)-2.0*Lad*grav*z_top/R/Tc,1.0/Lad);//the pressure at the top of the atmosphere
  sig_factor=0.001;
  P1=P_top;
  dP_factor=1.e7;
  //CHECK!!!!!: if z0>scale height, Td*R/(-grav)
  //Open data file
  data_output.open ("newmodelcpp.hse",ios::out);
  plot_output.open ("initialmodel_1500_T1_250.txt",ios::out);
  data_output << "# npts = 320567" << '\n' << "# num of variables = 4" << '\n' << "# density" << '\n' << "# temperature" <<'\n' << "# pressure" << '\n' << "# X " << '\n';
  dz=z_top/number_cell/crudeness_factor
  z=z_top+0.5*dz;
  P1=P_top;
  den1=den_top;
  den2=den_top*exp(-grav/R/Td*dz);//check den2>den1
 cout <<"den2/den1" << ' '<< den2/den1 << '\n';
  //Iterate over values until P>10^11 using constant dP
  do{
   
    z=z_top-dz
    dP=dz*grav*0.5*(den1+den2)
    P2 = P1-dP; //Note dP<0 for grav<0
    

    if(Pc>P2){
    T2 = Td * pow(1.0 + (Lad / (Lin - Lad))*pow((P2/Pc),exp1),exp2);
    }
    else{
    T2 = T_char * pow(P2/P_char,Lad);
    }
       
    if(Pc>P1){
    T1 = Td * pow(1.0 + (Lad / (Lin - Lad))*pow((P1/Pc),exp1),exp2);
    }
    else{
    T1 = T_char * pow(P1/P_char,Lad);
    }
          
    
    den1 = (P1/(R*T1));
    den2 = (P2/(R*T2));
     count++;
   // }
        
   // z = z - dz;
    P1 = P2;
      if(count % 100000 ==0){
      cout <<count << ' ' << z/1.0e5<< '\n';
      }
 
  }while(z>0.);
  
    count=0;
    
  do{
    dP=P1/dP_factor;
    P2 = P1-dP;
    
    
    if(Pc>P2){
      T2 = Td * pow(1.0 + (Lad / (Lin - Lad))*pow((P2/Pc),exp1),exp2);
    }
    else{
      T2 = T_char * pow(P2/P_char,Lad);
    }
    
    if(Pc>P1){
      T1 = Td * pow(1.0 + (Lad / (Lin - Lad))*pow((P1/Pc),exp1),exp2);
    }
    else{
      T1 = T_char * pow(P1/P_char,Lad);
    }
    
    
    den1 = (P1/(R*T1));
    den2 = (P2/(R*T2));
    dz = - (-P1+P2)* (1.0/grav)/((1.0/2.0)*(den1+den2));
      z=z-dz;
   // z=1.0/(1.0+exp(sig_factor*(P2-Pc)))*( z_top +  Td*R/(grav)*log(P2/P_top))+(1-1.0/(1.0+exp(sig_factor*(P2-Pc))))*( z_top+ + Td*R/(grav)*log(Pc/P_top)+ R/(grav)*Tc*pow(1.0/Pc,Lad)/Lad*(pow(P2,Lad)-pow(Pc,Lad)));
    if(z>=0.){
      data_output << setprecision(25) << z << ' ' << den1 << ' ' << T1 << ' ' << P1 << ' '<<  X << '\n';
      
      plot_output << setprecision(25) << z << ' ' << ' ' << den1 << ' '<< ' ' << T1 << ' ' << ' '<< P1/1.0e6 << ' ' << ' '<<  X << '\n';
      count++;
    }
      
    // z = z - dz;
    P1 = P2;
      if(count % 100000 ==0){
    cout << count  << ' ' << "density[g/cm^3]="<< ' '<< den1 << ' '<<' '<<"height[km]="<< ' '<<' '<< z/1.0e5 << "P[dyne/cm^2]="<< ' '<<' '<< P1/1.0e6 << "T[K]="<< ' '<<' '<< T1 << '\n' ;
      }
  
  
  }while(z<=z_top*1.0);
  
  
  
  cout<<Pc/1.0e6;
  cout<<Tc;
  //Close data file
  data_output.close();
  plot_output.close();
  return 0;
}
