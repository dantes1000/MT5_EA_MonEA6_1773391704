#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int BreakoutType = 0; // 0=Range, 1=BollingerBands, 2=ATR
input bool AllowLong = true; // Autoriser les positions long
input bool AllowShort = true; // Autoriser les positions short
input bool RequireVolumeConfirm = true; // Exiger confirmation du volume
input bool RequireRetest = false; // Attendre un retest avant entrée
input PERIOD RangeTF = PERIOD_D1; // Timeframe pour le calcul du range
input int TrendFilterEMA = 200; // Période EMA pour filtre de tendance (0=désactivé)
input PERIOD ExecTF = PERIOD_M15; // Timeframe pour l'exécution des trades (M15 ou M30)
input bool UseNewsFilter = true; // Activer le filtre d'actualités économiques
input int NewsMinutesBefore = 60; // Minutes avant la news pour suspendre le trading
input int NewsMinutesAfter = 30; // Minutes après la news pour reprendre le trading
input int NewsImpactLevel = 3; // Niveau d'impact minimum : 1=faible, 2=moyen, 3=fort
input bool CloseOnHighImpact = true; // Fermer les positions avant news à fort impact
input bool UseATRFilter = true; // Activer le filtre ATR
input int ATRPeriod = 14; // Période ATR
input int MinATRPips = 20; // ATR minimum requis (pips)
input int MaxATRPips = 150; // ATR maximum autorisé (pips)
input double ATR_Mult_Min = 1.25; // Multiplicateur ATR minimum pour valider un breakout
input double ATR_Mult_Max = 3.0; // Multiplicateur ATR maximum
input bool UseBBFilter = true; // Activer le filtre Bollinger Bands
input int BBPeriod = 20; // Période Bollinger Bands
input double BBDeviation = 2.0; // Déviation standard BB
input int Min_Width_Pips = 30; // Largeur BB minimum (pips)
input int Max_Width_Pips = 120; // Largeur BB maximum (pips)
input bool UseEMAFilter = true; // Activer le filtre EMA
input int EMAPeriod = 200; // Période EMA pour filtre de tendance
input PERIOD EMATf = PERIOD_H1; // Timeframe EMA
input bool UseADXFilter = true; // Activer le filtre ADX
input int ADXPeriod = 14; // Période ADX
input double ADXThreshold = 20.0; // Seuil ADX minimum
input bool UseRSIFilter = false; // Activer le filtre RSI
input int RSIPeriod = 14; // Période RSI
input int RSIOverbought = 70; // Niveau surachat RSI (ne pas acheter au-dessus)
input int RSIOversold = 30; // Niveau survente RSI (ne pas vendre en dessous)
input bool UseVolumeFilter = true; // Activer le filtre de volume
input int VolumePeriod = 20; // Période moyenne de volume
input double VolumeMultiplier = 1.5; // Multiplicateur volume minimum
input int Vol_Confirm_Type = 1; // 0=Tick, 1=Réel
input int MagicNumber = 123456; // Identifiant unique des ordres de l'EA
input string OrderComment = "RangeBreakEA"; // Commentaire sur les ordres
input int MaxSlippage = 3; // Slippage maximum autorisé (points)
input int MaxOrderRetries = 3; // Tentatives max d'envoi d'ordre
input bool UsePartialClose = false; // Activer la fermeture partielle
input double PartialCloseRR = 1.0; // R:R auquel fermer partiellement
input int PartialClosePct = 50; // Pourcentage à fermer partiellement (%)
input bool AllowAddPosition = false; // Autoriser ajout de position si en profit
input double AddPositionRR = 1.0; // R:R minimum pour ajouter une position
input int LotMethod = 0; // 0=% capital (Equity), 1=lot fixe, 2=lot par pip
input double RiskPercent = 1.0; // % du capital risqué par trade (0.5-1%)
input double FixedLot = 0.01; // Lot fixe (si LotMethod=1)
input double MinLot = 0.01; // Lot minimum
input double MaxLot = 5.0; // Lot maximum
input int StopLossPips = 0; // Stop Loss en pips (0=basé sur l'opposé du range)
input int TakeProfitPips = 0; // Take Profit en pips (0=dynamique ou R:R)
input double RiskRewardRatio = 1.5; // Ratio R:R minimum (si TP_Method=Fixed_RR)
input double MaxDailyDDPercent = 5.0; // Drawdown quotidien maximum (%)
input double MaxTotalDDPercent = 15.0; // Drawdown total maximum (%)
input int MaxOpenTrades = 1; // Nombre maximum de positions simultanées
input int MaxTradesPerDay = 3; // Nombre maximum de trades par jour
input int MinTimeBetweenTrades = 1; // Délai minimum entre trades (heures)
input int RangePeriodHours = 6; // Durée du range en heures (minuit-6h GMT)
input int MarginPips = 5; // Marge au-delà du High/Low avant entrée (pips)
input int MinRangePips = 20; // Range minimum pour valider le signal (pips)
input int MaxRangePips = 120; // Range maximum autorisé (pips)
input int Range_Calc = 0; // 0=Closed_Candles (bougies closes)
input int TradeStartHour = 8; // Heure de début du trading (GMT, ouverture London)
input int TradeEndHour = 23; // Heure de fin du trading (GMT)
input bool TradeMonday = true; // Autoriser le trading le lundi
input bool TradeTuesday = true; // Autoriser le trading le mardi
input bool TradeWednesday = true; // Autoriser le trading le mercredi
input bool TradeThursday = true; // Autoriser le trading le jeudi
input bool TradeFriday = true; // Autoriser le trading le vendredi
input bool WeekendClose = true; // Fermer toutes les positions avant le weekend
input int FridayCloseHour = 21; // Heure de fermeture le vendredi (GMT)
input bool CloseOutsideHours = false; // Fermer les positions hors fenêtre de trading
input int FastEMAPeriod = 20; // Période EMA rapide
input int SlowEMAPeriod = 50; // Période EMA lente
input int TrendEMAPeriod = 200; // Période EMA de tendance globale
input bool UseSuperTrend = false; // Activer SuperTrend comme filtre/trailing
input int SuperTrendPeriod = 10; // Période SuperTrend
input double SuperTrendMultiplier = 3.0; // Multiplicateur ATR SuperTrend
input PERIOD HTFTimeframe = PERIOD_H1; // Timeframe HTF pour la direction
input bool UseTrailingStop = true; // Activer le trailing stop
input int TrailingStopPips = 0; // Distance trailing stop (pips, 0=ATR-based)
input int TrailingStepPips = 0; // Pas du trailing stop (pips, 0=ATR-based)
input int Trail_Method = 1; // 0=Fixe, 1=ATR
input double Trail_Mult = 0.5; // Multiplicateur ATR pour le trailing
input int Trail_Activation_PC = 50; // Pourcentage de profit pour activer le trailing (50%)

// RiskManager.mqh - Complete risk management class
// Handles position sizing, stop loss, take profit, and partial close logic

class CRiskManager
{
private:
   // Input parameters
   int      BreakoutType;           // 0=Range, 1=BollingerBands, 2=ATR
   bool     AllowLong;              // Autoriser les positions long
   bool     AllowShort;             // Autoriser les positions short
   bool     RequireVolumeConfirm;   // Exiger confirmation du volume
   bool     RequireRetest;          // Attendre un retest avant entrée
   ENUM_TIMEFRAMES RangeTF;         // Timeframe pour le calcul du range
   int      TrendFilterEMA;         // Période EMA pour filtre de tendance (0=désactivé)
   ENUM_TIMEFRAMES ExecTF;          // Timeframe pour l'exécution des trades (M15 ou M30)
   bool     UseNewsFilter;          // Activer le filtre d'actualités économiques
   int      NewsMinutesBefore;      // Minutes avant la news pour suspendre le trading
   int      NewsMinutesAfter;       // Minutes après la news pour reprendre le trading
   int      NewsImpactLevel;        // Niveau d'impact minimum : 1=faible, 2=moyen, 3=fort
   bool     CloseOnHighImpact;      // Fermer les positions avant news à fort impact
   bool     UseATRFilter;           // Activer le filtre ATR
   int      ATRPeriod;              // Période ATR
   double   MinATRPips;             // ATR minimum requis (pips)
   double   MaxATRPips;             // ATR maximum autorisé (pips)
   double   ATR_Mult_Min;           // Multiplicateur ATR minimum pour valider un breakout
   double   ATR_Mult_Max;           // Multiplicateur ATR maximum
   bool     UseBBFilter;            // Activer le filtre Bollinger Bands
   int      BBPeriod;               // Période Bollinger Bands
   double   BBDeviation;            // Déviation standard BB
   double   Min_Width_Pips;         // Largeur BB minimum (pips)
   
   // Risk parameters
   double   RiskPercent;            // Risk percentage per trade
   double   MaxLotSize;             // Maximum lot size
   double   MinLotSize;             // Minimum lot size
   double   StopLossPips;           // Stop loss in pips
   double   TakeProfitPips;         // Take profit in pips
   double   TrailingStopPips;       // Trailing stop in pips
   double   BreakEvenPips;          // Break even trigger in pips
   bool     UsePartialClose;        // Enable partial close
   int      PartialCloseSteps;      // Number of partial close steps
   double   PartialClosePercent;    // Percentage to close at each step
   
   // Internal variables
   double   point;
   double   tickSize;
   double   tickValue;
   double   contractSize;
   double   accountBalance;
   double   accountEquity;
   
   // Indicator handles
   int      atrHandle;
   int      bbHandle;
   int      emaHandle;
   int      adxHandle;
   int      rsiHandle;
   int      volumeHandle;
   
   // News filter variables
   datetime lastNewsCheck;
   bool     isTradingAllowed;
   
public:
   // Constructor
   CRiskManager()
   {
      // Default values
      BreakoutType = 0;
      AllowLong = true;
      AllowShort = true;
      RequireVolumeConfirm = true;
      RequireRetest = false;
      RangeTF = PERIOD_D1;
      TrendFilterEMA = 200;
      ExecTF = PERIOD_M15;
      UseNewsFilter = true;
      NewsMinutesBefore = 60;
      NewsMinutesAfter = 30;
      NewsImpactLevel = 3;
      CloseOnHighImpact = true;
      UseATRFilter = true;
      ATRPeriod = 14;
      MinATRPips = 20;
      MaxATRPips = 150;
      ATR_Mult_Min = 1.25;
      ATR_Mult_Max = 3.0;
      UseBBFilter = true;
      BBPeriod = 20;
      BBDeviation = 2.0;
      Min_Width_Pips = 30;
      
      // Risk defaults
      RiskPercent = 2.0;
      MaxLotSize = 10.0;
      MinLotSize = 0.01;
      StopLossPips = 50;
      TakeProfitPips = 100;
      TrailingStopPips = 30;
      BreakEvenPips = 20;
      UsePartialClose = true;
      PartialCloseSteps = 2;
      PartialClosePercent = 50.0;
      
      // Initialize
      point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
      tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      contractSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
      accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
      accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      
      // Initialize indicator handles
      atrHandle = iATR(_Symbol, PERIOD_CURRENT, ATRPeriod);
      bbHandle = iBands(_Symbol, PERIOD_CURRENT, BBPeriod, 0, BBDeviation, PRICE_CLOSE);
      emaHandle = iMA(_Symbol, PERIOD_H1, TrendFilterEMA, 0, MODE_EMA, PRICE_CLOSE);
      adxHandle = iADX(_Symbol, PERIOD_CURRENT, 14);
      rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, 14, PRICE_CLOSE);
      volumeHandle = iVolumes(_Symbol, PERIOD_CURRENT, VOLUME_TICK);
      
      lastNewsCheck = 0;
      isTradingAllowed = true;
   }
   
   // Destructor
   ~CRiskManager()
   {
      // Release indicator handles
      if(atrHandle != INVALID_HANDLE) IndicatorRelease(atrHandle);
      if(bbHandle != INVALID_HANDLE) IndicatorRelease(bbHandle);
      if(emaHandle != INVALID_HANDLE) IndicatorRelease(emaHandle);
      if(adxHandle != INVALID_HANDLE) IndicatorRelease(adxHandle);
      if(rsiHandle != INVALID_HANDLE) IndicatorRelease(rsiHandle);
      if(volumeHandle != INVALID_HANDLE) IndicatorRelease(volumeHandle);
   }
   
   // Calculate position size based on risk
   double CalculateLotSize(double stopLossPips, double riskPercent = -1)
   {
      if(riskPercent < 0) riskPercent = RiskPercent;
      
      double riskAmount = accountBalance * riskPercent / 100.0;
      double pipValue = tickValue * (point / tickSize) * 10.0;
      
      if(pipValue == 0) return MinLotSize;
      
      double lots = riskAmount / (stopLossPips * pipValue);
      
      // Apply lot size constraints
      lots = MathMin(lots, MaxLotSize);
      lots = MathMax(lots, MinLotSize);
      
      // Normalize to step size
      double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
      lots = MathRound(lots / lotStep) * lotStep;
      
      return lots;
   }
   
   // Calculate stop loss price
   double CalculateStopLossPrice(int orderType, double entryPrice, double stopLossPips)
   {
      double stopPrice = 0;
      
      if(orderType == ORDER_TYPE_BUY)
      {
         stopPrice = entryPrice - stopLossPips * point * 10;
      }
      else if(orderType == ORDER_TYPE_SELL)
      {
         stopPrice = entryPrice + stopLossPips * point * 10;
      }
      
      return NormalizeDouble(stopPrice, (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));
   }
   
   // Calculate take profit price
   double CalculateTakeProfitPrice(int orderType, double entryPrice, double takeProfitPips)
   {
      double tpPrice = 0;
      
      if(orderType == ORDER_TYPE_BUY)
      {
         tpPrice = entryPrice + takeProfitPips * point * 10;
      }
      else if(orderType == ORDER_TYPE_SELL)
      {
         tpPrice = entryPrice - takeProfitPips * point * 10;
      }
      
      return NormalizeDouble(tpPrice, (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS));
   }
   
   // Check if trading is allowed (news filter)
   bool IsTradingAllowed()
   {
      if(!UseNewsFilter) return true;
      
      datetime currentTime = TimeCurrent();
      
      // Check every minute
      if(currentTime - lastNewsCheck >= 60)
      {
         lastNewsCheck = currentTime;
         isTradingAllowed = CheckNewsImpact();
      }
      
      return isTradingAllowed;
   }
   
   // Check news impact using FFCal indicator
   bool CheckNewsImpact()
   {
      // This is a simplified implementation
      // In real implementation, you would use iCustom with FFCal indicator
      
      datetime currentTime = TimeCurrent();
      
      // Simulate news events (replace with actual FFCal implementation)
      // For demonstration, assume no high impact news
      
      // If CloseOnHighImpact is true and high impact news is coming
      // close positions and return false
      
      return true; // Trading allowed
   }
   
   // Close positions before high impact news
   void ClosePositionsBeforeNews()
   {
      if(!CloseOnHighImpact) return;
      
      // Check if high impact news is within NewsMinutesBefore
      // If yes, close all positions
      
      // Implementation would use FFCal indicator to check upcoming news
   }
   
   // Apply trailing stop
   void ApplyTrailingStop(ulong ticket, double currentPrice)
   {
      if(TrailingStopPips <= 0) return;
      
      if(PositionSelectByTicket(ticket))
      {
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentStop = PositionGetDouble(POSITION_SL);
         int positionType = (int)PositionGetInteger(POSITION_TYPE);
         
         double newStop = currentStop;
         
         if(positionType == POSITION_TYPE_BUY)
         {
            double trailLevel = currentPrice - TrailingStopPips * point * 10;
            if(trailLevel > currentStop && trailLevel > openPrice)
            {
               newStop = trailLevel;
            }
         }
         else if(positionType == POSITION_TYPE_SELL)
         {
            double trailLevel = currentPrice + TrailingStopPips * point * 10;
            if(trailLevel < currentStop && trailLevel < openPrice)
            {
               newStop = trailLevel;
            }
         }
         
         if(newStop != currentStop)
         {
            MqlTradeRequest request = {};
            MqlTradeResult result = {};
            
            request.action = TRADE_ACTION_SLTP;
            request.position = ticket;
            request.symbol = _Symbol;
            request.sl = newStop;
            request.tp = PositionGetDouble(POSITION_TP);
            request.magic = PositionGetInteger(POSITION_MAGIC);
            
            OrderSend(request, result);
         }
      }
   }
   
   // Apply break even
   void ApplyBreakEven(ulong ticket, double currentPrice)
   {
      if(BreakEvenPips <= 0) return;
      
      if(PositionSelectByTicket(ticket))
      {
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentStop = PositionGetDouble(POSITION_SL);
         int positionType = (int)PositionGetInteger(POSITION_TYPE);
         
         double profitPips = 0;
         
         if(positionType == POSITION_TYPE_BUY)
         {
            profitPips = (currentPrice - openPrice) / (point * 10);
            if(profitPips >= BreakEvenPips && currentStop < openPrice)
            {
               MqlTradeRequest request = {};
               MqlTradeResult result = {};
               
               request.action = TRADE_ACTION_SLTP;
               request.position = ticket;
               request.symbol = _Symbol;
               request.sl = openPrice;
               request.tp = PositionGetDouble(POSITION_TP);
               request.magic = PositionGetInteger(POSITION_MAGIC);
               
               OrderSend(request, result);
            }
         }
         else if(positionType == POSITION_TYPE_SELL)
         {
            profitPips = (openPrice - currentPrice) / (point * 10);
            if(profitPips >= BreakEvenPips && currentStop > openPrice)
            {
               MqlTradeRequest request = {};
               MqlTradeResult result = {};
               
               request.action = TRADE_ACTION_SLTP;
               request.position = ticket;
               request.symbol = _Symbol;
               request.sl = openPrice;
               request.tp = PositionGetDouble(POSITION_TP);
               request.magic = PositionGetInteger(POSITION_MAGIC);
               
               OrderSend(request, result);
            }
         }
      }
   }
   
   // Partial close logic
   void ApplyPartialClose(ulong ticket, double currentPrice)
   {
      if(!UsePartialClose || PartialCloseSteps <= 0) return;
      
      if(PositionSelectByTicket(ticket))
      {
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double takeProfit = PositionGetDouble(POSITION_TP);
         double volume = PositionGetDouble(POSITION_VOLUME);
         int positionType = (int)PositionGetInteger(POSITION_TYPE);
         
         if(takeProfit == 0) return;
         
         double profitPercent = 0;
         
         if(positionType == POSITION_TYPE_BUY)
         {
            profitPercent = (currentPrice - openPrice) / (takeProfit - openPrice) * 100;
         }
         else if(positionType == POSITION_TYPE_SELL)
         {
            profitPercent = (openPrice - currentPrice) / (openPrice - takeProfit) * 100;
         }
         
         // Calculate which step we're at
         double stepSize = 100.0 / PartialCloseSteps;
         
         for(int i = 1; i <= PartialCloseSteps; i++)
         {
            double triggerLevel = stepSize * i;
            
            if(profitPercent >= triggerLevel)
            {
               // Check if we haven't already closed at this level
               // This would require tracking partial closes per position
               
               double closeVolume = volume * (PartialClosePercent / 100.0);
               
               MqlTradeRequest request = {};
               MqlTradeResult result = {};
               
               request.action = TRADE_ACTION_DEAL;
               request.symbol = _Symbol;
               request.volume = closeVolume;
               request.type = (positionType == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
               request.price = currentPrice;
               request.position = ticket;
               request.deviation = 10;
               request.magic = PositionGetInteger(POSITION_MAGIC);
               
               OrderSend(request, result);
               
               // Record that we've closed at this level
               break;
            }
         }
      }
   }
   
   // Validate entry with all filters
   bool ValidateEntry(int orderType, double entryPrice)
   {
      // Check if trading is allowed (news filter)
      if(!IsTradingAllowed()) return false;
      
      // Check long/short permissions
      if(orderType == ORDER_TYPE_BUY && !AllowLong) return false;
      if(orderType == ORDER_TYPE_SELL && !AllowShort) return false;
      
      // Check trend filter
      if(TrendFilterEMA > 0)
      {
         double emaValue = GetIndicatorValue(emaHandle, 0, 0);
         double currentPrice = (orderType == ORDER_TYPE_BUY) ? 
                              SymbolInfoDouble(_Symbol, SYMBOL_ASK) : 
                              SymbolInfoDouble(_Symbol, SYMBOL_BID);
         
         if(orderType == ORDER_TYPE_BUY && currentPrice <= emaValue) return false;
         if(orderType == ORDER_TYPE_SELL && currentPrice >= emaValue) return false;
      }
      
      // Check ATR filter
      if(UseATRFilter)
      {
         double atrValue = GetIndicatorValue(atrHandle, 0, 0) / point / 10;
         
         if(atrValue < MinATRPips || atrValue > MaxATRPips) return false;
         
         // Check breakout validation with ATR multiplier
         // This would depend on the specific breakout logic
      }
      
      // Check Bollinger Bands filter
      if(UseBBFilter)
      {
         double bbUpper = GetIndicatorValue(bbHandle, 1, 0);
         double bbLower = GetIndicatorValue(bbHandle, 2, 0);
         double bbWidth = (bbUpper - bbLower) / point / 10;
         
         if(bbWidth < Min_Width_Pips) return false;
      }
      
      // Check volume confirmation
      if(RequireVolumeConfirm)
      {
         double currentVolume = GetIndicatorValue(volumeHandle, 0, 0);
         double volumeSMA = GetIndicatorValue(volumeHandle, 1, 0); // Assuming SMA 20
         
         if(volumeSMA == 0 || currentVolume / volumeSMA < 1.5) return false;
      }
      
      // Check ADX filter
      double adxValue = GetIndicatorValue(adxHandle, 0, 0);
      if(adxValue < 20) return false;
      
      // Check RSI filter
      double rsiValue = GetIndicatorValue(rsiHandle, 0, 0);
      if(orderType == ORDER_TYPE_BUY && rsiValue > 70) return false;
      if(orderType == ORDER_TYPE_SELL && rsiValue < 30) return false;
      
      return true;
   }
   
   // Get indicator value
   double GetIndicatorValue(int handle, int buffer, int shift)
   {
      double value[1];
      
      if(CopyBuffer(handle, buffer, shift, 1, value) == 1)
      {
         return value[0];
      }
      
      return 0;
   }
   
   // Update account information
   void UpdateAccountInfo()
   {
      accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
      accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   }
   
   // Set risk parameters
   void SetRiskParameters(double riskPercent, double maxLot, double minLot,
                         double slPips, double tpPips, double trailPips,
                         double bePips, bool usePartial, int partialSteps,
                         double partialPercent)
   {
      RiskPercent = riskPercent;
      MaxLotSize = maxLot;
      MinLotSize = minLot;
      StopLossPips = slPips;
      TakeProfitPips = tpPips;
      TrailingStopPips = trailPips;
      BreakEvenPips = bePips;
      UsePartialClose = usePartial;
      PartialCloseSteps = partialSteps;
      PartialClosePercent = partialPercent;
   }
   
   // Set breakout parameters
   void SetBreakoutParameters(int type, bool allowLong, bool allowShort,
                             bool volumeConfirm, bool retest,
                             ENUM_TIMEFRAMES rangeTF, int trendEMA,
                             ENUM_TIMEFRAMES execTF)
   {
      BreakoutType = type;
      AllowLong = allowLong;
      AllowShort = allowShort;
      RequireVolumeConfirm = volumeConfirm;
      RequireRetest = retest;
      RangeTF = rangeTF;
      TrendFilterEMA = trendEMA;
      ExecTF = execTF;
   }
   
   // Set news filter parameters
   void SetNewsFilterParameters(bool useFilter, int minutesBefore,
                               int minutesAfter, int impactLevel,
                               bool closeOnImpact)
   {
      UseNewsFilter = useFilter;
      NewsMinutesBefore = minutesBefore;
      NewsMinutesAfter = minutesAfter;
      NewsImpactLevel = impactLevel;
      CloseOnHighImpact = closeOnImpact;
   }
   
   // Set indicator filter parameters
   void SetIndicatorFilterParameters(bool useATR, int atrPeriod,
                                    double minATR, double maxATR,
                                    double atrMultMin, double atrMultMax,
                                    bool useBB, int bbPeriod,
                                    double bbDev, double minWidth)
   {
      UseATRFilter = useATR;
      ATRPeriod = atrPeriod;
      MinATRPips = minATR;
      MaxATRPips = maxATR;
      ATR_Mult_Min = atrMultMin;
      ATR_Mult_Max = atrMultMax;
      UseBBFilter = useBB;
      BBPeriod = bbPeriod;
      BBDeviation = bbDev;
      Min_Width_Pips = minWidth;
   }
};

// Helper functions from reference patterns
bool IsNewBar(ENUM_TIMEFRAMES tf)
{
   static datetime lastBarTime = 0;
   datetime currentBar = iTime(_Symbol, tf, 0);
   if(lastBarTime != currentBar)
   {
      lastBarTime = currentBar;
      return true;
   }
   return false;
}

bool IsBreakoutLong(double level, double tolerancePips = 0)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double ask   = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   return ask > level + tolerancePips * point * 10;
}

bool IsBreakoutShort(double level, double tolerancePips = 0)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double bid   = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   return bid < level - tolerancePips * point * 10;
}

bool IsRetestLong(double level, double retestTolerancePips)
{
   double point   = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol     = retestTolerancePips * point * 10;
   double lowBar  = iLow(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (lowBar <= level + tol && closeBar > level);
}

bool IsRetestShort(double level, double retestTolerancePips)
{
   double point    = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol      = retestTolerancePips * point * 10;
   double highBar  = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (highBar >= level - tol && closeBar < level);
}

bool IsTrendLong(int fastHandle, int slowHandle, int signalShift)
{
   double fast0 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift);
   double slow0 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift);
   double fast1 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift + 1);
   double slow1 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift + 1);
   return (fast1 <= slow1 && fast0 > slow0);
}

bool IsTrendShort(int fastHandle, int slowHandle, int signalShift)
{
   double fast0 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift);
   double slow0 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift);
   double fast1 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift + 1);
   double slow1 = iMA(_Symbol, PERIOD_CURRENT, 1, 0, MODE_EMA, PRICE_CLOSE, signalShift + 1);
   return (fast1 >= slow1 && fast0 < slow0);
}