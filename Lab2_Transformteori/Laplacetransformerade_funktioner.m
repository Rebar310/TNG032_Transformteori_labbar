
% Som vi nämnt ovan är trigonometriska funktioner, 
% exponentialfunktioner och polynom typiskt "snälla funktioner". 
% Deras laplacetransformerade motsvarighet är rationella funktioner, 
% se gärna formlerna L12–L18 på formelbladet.

% Eftersom man gör en kvantitativ tolkning med hjälp av laplacetransformen, 
% så är man intresserad av funktionens signifikativa egenskaper och hur man 
% enkelt kan avläsa detta i den laplacetransformerade storheten.


% Uppgift 1 -------------------------------------------------------------

% Bilda tIntervall som en tidsvektor med värdena från 0 till 6,  vare sig
% med kolonnotationen, d.v.s. startvärde:steglängd:slutvärde, eller
% med linspace, d.v.s. linspace(startvärde, slutvärde, antalet tidspunkter).

% a)
%t = 0:0.1:6; % Startvärde:steglängd:slutvärde
t = linspace(0, 6, 100); % Startvärde, slutvärde, antal punkter

% b)
% Definiera en anonym funktion expfun som tar in två parametrar, 
% talet/vektorn t och talet a, och som returnerar värdet på uttrycket  1−e−at.

% Definiera värden för a
a_values = [0.6, 1, 2];

% Definiera funktionen
expfun = @(t, a) 1 - exp(-a * t);

% c)
% Rita ut grafen till funktionen  f(t)=1−e−t/2 , m.h.a. kommandot
plot(tIntervall, expfun(tIntervall, 1/2));

% d) Rita ut graferna till funktionen   y=1−e−at
% då a=0.6, a=1, a=2
% För vilket värde på a konvergerar funktionskurvan mot slutvärdet  y=1 som långsammast?


% Rita ut graferna
figure;
hold on;
for i = 1:length(a_values)
    a = a_values(i);
    y = expfun(t, a);
    plot(t, y, 'DisplayName', ['a = ' num2str(a)]);
end

% Format på grafen
xlabel('t');
ylabel('y = 1 - e^{-a t}');
title('Funktionskurva för olika a-värden');
legend;
grid on;
hold off;

% d) svar: a = 0.6 når y= 1 långsammast

%% Uppgift 2 ---------------------------------------------------------------------

% Skapa tidsvektor från 0 till 6
t = linspace(0, 6, 1000); % Fler punkter för bättre upplösning

% Definiera funktionen
expfun = @(t) 1 - exp(-2.8 * t);

% Beräkna funktionsvärden
y = expfun(t);

% Rita grafen
figure;
plot(t, y, 'b', 'LineWidth', 1.5);
hold on;

% Rita en horisontell linje vid y = 0.63
y_target = 0.63;
yline(y_target, 'r--', 'LineWidth', 1.5);

% Hitta t-värdet där y överstiger 0.63
t_target_index = find(y >= y_target, 1); % Första index där y >= 0.63
t_target = t(t_target_index);

% Markera punkten på grafen
plot(t_target, y_target, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% Format på grafen
xlabel('t');
ylabel('y = 1 - e^{-2.8t}');
title('Graf av y = 1 - e^{-2.8t}');
legend('y = 1 - e^{-2.8t}', 'y = 0.63', 'Plats där y = 0.63', 'Location', 'southeast');
grid on;
hold off;

% Visa det avlästa t-värdet i kommandofönstret
fprintf('Funktionsvärdet överstiger 0.63 vid t ≈ %.3f\n', t_target);

% svar: t = 0.360



%% Uppgift (Diskussionsuppgift A ) ------------------------------------------------------------
% Beskriv med egna ord hur man kan avgöra att funktionen konvergerar snabbt (eller långsamt) mot slutvärdet  1
% genom att titta på det rationella uttrycket som fåtts m.h.a. laplacetransformen.

% Man kan avgöra hur snabbt funktionen konvergerar mot sitt slutvärde genom att analysera nämnaren i det rationella uttrycket från Laplacetransformen. 
% Om parametern a är stor, blir nämnaren dominerad av a, vilket gör att transformen avtar snabbare i tidsplanet, vilket innebär snabbare konvergens. 
% Om a är liten, är avklingningen långsammare, vilket gör att funktionen når sitt slutvärde långsamt.

%% Uppgift 3 -------------------------------------------

tIntervall = linspace(0, 6, 1000); % Skapa en tidsvektor från 0 till 6 med många punkter

expsin = @(t, b) 1 - exp(-t) .* cos(b * t) - (1 ./ b) .* exp(-t) .* sin(b * t);

figure;
hold on;
plot(tIntervall, expsin(tIntervall, 2), 'b', 'DisplayName', 'b = 2');
plot(tIntervall, expsin(tIntervall, 4), 'r', 'DisplayName', 'b = 4');
plot(tIntervall, expsin(tIntervall, 5), 'g', 'DisplayName', 'b = 5');

xlabel('t');
ylabel('y = 1 - e^{-t} cos(bt) - (1/b) e^{-t} sin(bt)');
title('Funktionens beteende för olika värden på b');
legend;
grid on;
hold off;

y_target = 0.9; % Målvärde

b_values = [2, 4, 5];
t_times = zeros(size(b_values));

for i = 1:length(b_values)
    b = b_values(i);
    y = expsin(tIntervall, b);
    t_index = find(y >= y_target, 1); % Hitta första index där y >= 0.9
    t_times(i) = tIntervall(t_index);
    
    fprintf('För b = %d når funktionen värdet 0.9 vid t ≈ %.3f\n', b, t_times(i));
end

% Bestäm vilket b som tar längst tid att nå 0.9
[~, slowest_index] = max(t_times);
fprintf('Det tar längst tid för b = %d att nå värdet 0.9.\n', b_values(slowest_index));

% Svar :Det tar längst tid för b = 2 att nå värdet 0.9


%% Diskussionsuppgift B

% Genom att analysera nämnaren i Laplacetransformen ser vi att termen bestämmer både hur snabbt funktionen konvergerar och dess svängighet. 
% Om b är stort, blir oscillationerna kraftigare eftersom termen styr svängningarnas frekvens. 
% Om b är litet, blir funktionen mer dämpad och konvergerar utan kraftiga svängningar. 
% Faktorn i nämnaren som innehåller s+1 påverkar hur snabbt funktionen avtar, 
% där större värden på b leder till mer oscillation innan funktionen stabiliseras vid sitt slutvärde.



