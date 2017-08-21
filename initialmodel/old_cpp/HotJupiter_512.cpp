//July 25

#include<iostream>
#include<cmath>
#include<fstream>
#include<iomanip>

using namespace std;

int main(){
  ofstream data_output,plot_output;
  double P1, Pc,Pd,dP, Lad, Lin,P_char,T_char,Tc,P_bottom,P_top,den_top,z_top;
  double R , z , den1 , grav , T1, Td, z0;
  double exp1, exp2,exp3,sig_factor,dP_factor,number_cell,cell_factor;
  double X = 1.0,buffer_height,T_buffer,den_buffer;
  double P2, dz, den2, T2,dP_factor_max, dP_factor_min,error_expected,error,P2_temp;
    int alpha=1, beta=0, count = 0,count_cell,count2=0 , count3=0;
 // static double P[10000000],T[10000000],den[10000000],y[10000000];
  double P[5000],T[5000],den[5000],y[5000];
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

  exp1=1 + alpha;
  exp2=(1.0/(4.0-beta));
  exp3=exp1/exp2;
//  P0 = 9.0e11;//1.0e11;
  
  den_top=1.e-8 ;// the density limit at the top of the atmosphere
  P_top=den_top*R*Td ;//the pressure limit at the density limit
  den_buffer=1.e-10;
  T_buffer=100.0;
  z_top=1.0e10; //the size of the computation box
  Tc = Td * pow(Lin/(Lin-Lad),exp2);
  Pc = P_char * pow(Tc/T_char,1.0/Lad);
  Pd = pow((Lin-Lad)/(2.0*Lin-Lad),1.0/exp1)*Pc;
//  P0=pow(pow(Pd,Lad)-pow(Pc,Lad)*Lad/Tc*(Td*log(Pd/P_top)-2.0*(-grav)/R*z0),1.0/Lad);
  P_bottom=Pc*pow(1.0+Lad*(Td/Tc)*log(P_top/Pc)-2.0*Lad*grav*z_top/R/Tc,1.0/Lad);//the pressure at the top of the atmosphere
  sig_factor=0.001;
  number_cell=512.0;
  P1=P_top;
  dP_factor=1.5;
  dP_factor_max=1.e12;
  dP_factor_min=1.e10;
  cell_factor=1.e16;// this factor determines the range of y within which dP=P/dP_factor with dP_factor=dP_factor_max.
  
  data_output.open ("newmodelcpp.hse",ios::out);
  plot_output.open ("initialmodel_1500_T1_250.txt",ios::out);
  z=z_top;//+0.5*z_top/number_cell;
  P1=P_top;
  buffer_height=z_top*1.0/3.0;
  
  //Iterate over values until P>10^11 using constant dP
  count=0;
  error_expected=1.e3/z_top;
  z0=10.0;
  
  do{
    if(z>buffer_height){
      den1 = den_top;
      den2 = den_top;
      T1=T_buffer;
      T2=T_buffer;
      P1=R*T_buffer*den1;
      P2=R*T_buffer*den2;
      T[count2]=T1;
      P[count2]=P1;
      den[count2]=den1;
      y[count2]=z;
      z=z_top-z_top/number_cell*(float(count_cell)+0.5);
      count2++;
      count++;
      count_cell++;
      P1=R*Td*den1;
      P2=R*Td*den2;
  cout<<"In buffer" << ' '<< count_cell << ' ' << z<<' '<< dz/(z_top/number_cell) << ' ' << error << '\n';
    }
    else{
      
      
        dP=P1/dP_factor;
        P2 = P1+dP;
        P2_temp=0;
      if(Pc>P1){
        T1 = Td * pow(1.0 + (Lad / (Lin - Lad))*pow((P1/Pc),exp1),exp2);
      }
      else{
        T1 = T_char * pow(P1/P_char,Lad);
      }
      den1 = (P1/(R*T1));
    do{
          if(Pc>P2){
            T2 = Td * pow(1.0 + (Lad / (Lin - Lad))*pow((P2/Pc),exp1),exp2);
          }
          else{
            T2 = T_char * pow(P2/P_char,Lad);
          }
        
      
        
      
          den2 = (P2/(R*T2));
          dz = abs ((-P1+P2)* (1.0/grav)/((1.0/2.0)*(den1+den2)));

        error=dz-z_top/number_cell;//*float(count_cell);
      count++;
      if(count % 10000000 ==0){
  cout << setprecision(15)<<"In atmos." << ' '<< count_cell <<' '<<  abs(abs((-P1+P2)/dz)-(grav)*((1.0/2.0)*(den1+den2)))<< ' ' << error << ' ' <<dz/(z_top/number_cell)<< '\n';
      }
      if(abs(error)>z_top/number_cell){
        dP=dP*0.5;
        if(error>0){
          P2=P2-dP;
        }
        else{
          P2=P2+dP;
        }
//      cout<<"haha"<<' '<< dP<< ' ' <<P2<<' '<<dz<<' '<< error << ' ' <<z_top/number_cell<<'\n';
      }
      else if(abs(error)>error_expected){
            if(error>0){
 // cout<<"haha1"<<' '<<count_cell<<' ' <<dz/(z_top/number_cell)<<' ' <<P1 << ' ' << P2 << ' ' <<den1<<  ' '<<den2<<' '<<dz<<' ' << error << '\n';
              
              if((P2+P2_temp)/2.0<P1){
                do{
                  count3++;
                  if(count3==int(z0)){
                    count3=0;
                    z0=z0*10.0;
                  }
 //                 cout<<"haha0"<<' '<<count_cell<<' ' <<(P2+P2_temp)/2.0/P1 << ' ' << count3 << ' ' << z0 << '\n';
                }while((P2+P2_temp)/(2.0-float(count3)/z0)<P1);
                P2=(P2+P2_temp)/(2.0-float(count3)/z0);
                count3=0;
              }
              else{
                P2=(P2+P2_temp)/2.0;
//          cout<<"haha0"<<' '<<count_cell<<' ' <<dz/(z_top/number_cell)<<' ' <<P2_temp<< ' ' << P2<< ' ' <<error << '\n';
              }
              //P2-P2/dP_factor*1.e-7*pow(abs(error/error_expected),0.2);
      //        if(P2<P1){
      //          do{
      //            count3++;
      //            P2=P2*float(count3+1)/float(count3+2);
       //
       //           }while(P2<P1);
       //         count3=0;
       //       }
              
              
            }
            else if(error<0){
              P2_temp=max(P2,0.0);
              P2=P2+P2/dP_factor*1.e-9*pow(abs(error/error_expected),0.16);
//  cout<<"haha4"<<' '<<count_cell<<' ' <<dz/(z_top/number_cell)<<' '<< P2 << ' ' <<P2/dP_factor*1.e-7*pow(abs(error/error_expected),0.15) <<  ' '<<error<<'\n';

              
            }
          
          }
      
          else if(abs(error)<error_expected){
  cout<<"RECORD"<< ' ' <<count_cell<< ' ' << abs(abs((-P1+P2)/dz)+(grav)*((1.0/2.0)*(den1+den2)))<< ' ' << error << ' ' <<dz/(z_top/number_cell)<< '\n';
          z=z-z_top/number_cell;
            if(z<0){
              break;
            }
          T[count2]=T2;
          P[count2]=P2;
          den[count2]=den2;
          y[count2]=z;
          count2++;
          count++;
          P1 = P2;
          count_cell++;
          }
      if (dP<1.e-20){
        return 0;
      }
      }while(P1!=P2);
    }
  }while(z>=0);
  
    
    
    data_output << "# npts = " << count2 <<'\n' << "# num of variables = 4" << '\n' << "# density" << '\n' << "# temperature" <<'\n' << "# pressure" << '\n' << "# X " << '\n';
 
  do{
    --count2;
    data_output << setprecision(25) << y[count2] << ' ' << den[count2] << ' ' << T[count2] << ' ' << P[count2] << ' '<<  X << '\n';

  }while(count2>0);
    
    
  cout<<"count= " << count2<<'\n';
  
  //cout<<"count"<< ' ' <<count2 << '\n';
  cout<<"Pc[dyne/cm^{2}]= "<< ' ' << Pc << '\n';
  cout<<"Tc[K]= "<< ' ' << Tc << '\n';
  //Close data file
  data_output.close();
  plot_output.close();

  return 0;
  
  
  
}

  
  
  
  

