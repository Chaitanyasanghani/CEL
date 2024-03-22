%The script uses the finite difference method to solve the equation of motion for a mass / spring System. 
% The displacement, velocity, acceleration

close all
clear 
clc

% mass  [0.506606]
   m = 5; 
% spring constant   [20]
   k = 100; 
% amplitude
   A = 8.0; 

disp('   ')
   f0 = sqrt(k/m)/(2*pi);       % resonance (natural) frequency
   fprintf('Resonance frequency  f0 = %3.5f Hz  \n',f0)
disp('   ')
% damping constant   [ 0 to 20 ?]
   b = input('\n   Damping constant [0 to 20]  b =  '); 
%  flagF
    flagF = input('\n   Driving force: 1 (Sinusoidal) or 2 (Impulsive) or 3 (free oscillation)  flagF =  ');
% driving frequency
   if flagF == 1
      fD = input('\n   Driving frequency [0.1 to 4]  fD = ');
   end
% max simulation time interval  [10]   
   tMax = input('\n   max simulation time interval [10]  tMax = ');                   
   
   
   T0 = 1/f0;                   % natural period of oscillation
   w0 = 2*pi*f0;                % natural angular frequency
   nmax = 8001;                 % max number of time steps
   tMin = 0;                    % tmin
  
   dt = (tMax-tMin)/(nmax-1);   % time step
   t = tMin : dt : tMax;        % simulation time
      
   x = zeros(nmax,1);    % displacement
   v = zeros(nmax,1);    % velocity
   a = zeros(nmax,1);    % acceleration
   FD = zeros(nmax,1);   % force acting on mass


%  driving force

if flagF == 2
    FD(500:3000) = 10;     %   impulsive driving force
end
    
if flagF == 1
   wD = 2*pi*fD;
   FD = A*sin(wD*t);     %   sinusoidal driving force
   x(2) = x(1)*sin(2*pi*dt/T0);
end

if flagF == 3
    x(1) = 1; 
    x(2) = x(1)*cos(w0*dt);
end

% Coefficients
c0 = 1 + (b/m)*(dt/2);
c1 = (2-(k/m)*dt*dt)/c0;
c11 = (2-(k/m)*dt*dt);
c2 =((b/m)*(dt/2)-1)/c0;
c3 = (dt*dt/m)/c0;

%  Finite difference Calculations
%  Position
for c = 3 : nmax
   x(c) = c1*x(c-1) + c2*x(c-2) + c3*FD(c-1);
end

% Velocity
v(1) = (x(2)-x(1))/dt;
v(nmax) = (x(nmax)- x(nmax-1))/dt;
for n = 2 : nmax-1
   v(n) = (x(n+1)- x(n-1))/(2*dt);
end

% Acceleration
a(1) = (v(2)-v(1))/dt;
a(nmax) = (v(nmax)- v(nmax-1))/dt;
for n = 2 : nmax-1
   a(n) = (v(n+1)- v(n-1))/(2*dt);
end

%s = 'damping coeff. b = '& numStr(b);
s = sprintf('b = %.1f ',b);


figure(1)
   pos = [0.07 0.05 0.32 0.32];
   set(gcf,'Units','normalized');
   set(gcf,'Position',pos);
   set(gcf,'color','w'); 
plot(t,x,'LineWidth',2); 
title(s)
ylabel('position  x  (m)','FontSize',18)
xlabel('time  t  (s)','FontSize',18)
grid on
set(gca,'fontsize',14)

figure(2)
   pos = [0.37 0.05 0.32 0.32];
   set(gcf,'Units','normalized');
   set(gcf,'Position',pos);
   set(gcf,'color','w'); 
plot(t,v,'LineWidth',3);
title(s)
ylabel('velocity  v  (m/s)','FontSize',18)
xlabel('time  t  (s)','FontSize',18)
grid on
set(gca,'fontsize',14)

figure(3)
   pos = [0.67 0.05 0.32 0.32];
   set(gcf,'Units','normalized');
   set(gcf,'Position',pos);
   set(gcf,'color','w'); 
plot(t,a,'LineWidth',3);
title(s)
ylabel('acceleration  a  (m/s²)','FontSize',18)
xlabel('time  t  (s)','FontSize',18)
grid on
set(gca,'fontsize',14)