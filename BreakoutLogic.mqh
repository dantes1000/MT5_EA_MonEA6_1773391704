//+------------------------------------------------------------------+
//|                                                      BreakoutLogic.mqh |
//|                        Copyright 2023, MetaQuotes Ltd.             |
//|                                             https://www.mql5.com   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int Max_Width_Pips = 120; // Largeur BB maximum (pips)
input bool UseEMAFilter = true; // Activer le filtre EMA
input int EMAPeriod = 200; // Période EMA pour filtre de tendance
input PERIOD EMATf = PERIOD_H1; // Timeframe EMA
input double ADXThreshold = 20.0; // Seuil ADX minimum
input int RSIOverbought = 70; // Niveau surachat RSI (ne pas acheter au-dessus)
input int RSIOversold = 30; // Niveau survente RSI (ne pas vendre en dessous)
input int VolumePeriod = 20; // Période moyenne de volume
input double VolumeMultiplier = 1.5; // Multiplicateur volume minimum
input int Vol_Confirm_Type = 1; // 0=Tick, 1=Réel
input string OrderComment = "RangeBreakEA"; // Commentaire sur les ordres
input int MaxSlippage = 3; // Slippage maximum autorisé (points)
input int MaxOrderRetries = 3; // Tentatives max d'envoi d'ordre
input bool UsePartialClose = false; // Activer la fermeture partielle
input double PartialCloseRR = 1.0; // R:R auquel fermer partiellement
input int PartialClosePct = 50; // Pourcentage à fermer partiellement (%)
input bool AllowAddPosition = false; // Autoriser ajout de position si en profit
input double AddPositionRR = 1.0; // R:R minimum pour ajouter une position
input int LotMethod = 0; // 0=% capital (Equity), 1=lot fixe, 2=lot par pip
input double FixedLot = 0.01; // Lot fixe (si LotMethod=1)
input double MinLot = 0.01; // Lot minimum
input double MaxLot = 5.0; // Lot maximum
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

//+------------------------------------------------------------------+
//| Input parameters                                                 |
//+------------------------------------------------------------------+
// Breakout parameters
input int      BreakoutType = 0;               // 0=Range, 1=BollingerBands, 2=ATR
input bool     AllowLong = true;               // Allow long positions
input bool     AllowShort = true;              // Allow short positions
input bool     RequireVolumeConfirm = true;    // Require volume confirmation
input bool     RequireRetest = false;          // Wait for retest before entry
input ENUM_TIMEFRAMES RangeTF = PERIOD_D1;     // Timeframe for range calculation
input int      TrendFilterEMA = 200;           // EMA period for trend filter (0=disabled)
input ENUM_TIMEFRAMES ExecTF = PERIOD_M15;     // Timeframe for trade execution

// News filter parameters
input bool     UseNewsFilter = true;           // Enable economic news filter
input int      NewsMinutesBefore = 60;         // Minutes before news to suspend trading
input int      NewsMinutesAfter = 30;          // Minutes after news to resume trading
input int      NewsImpactLevel = 3;            // Minimum impact level: 1=low, 2=medium, 3=high
input bool     CloseOnHighImpact = true;       // Close positions before high impact news

// Indicator filter parameters
input bool     UseATRFilter = true;            // Enable ATR filter
input int      ATRPeriod = 14;                 // ATR period
input double   MinATRPips = 20;                // Minimum ATR required (pips)
input double   MaxATRPips = 150;               // Maximum ATR allowed (pips)
input double   ATR_Mult_Min = 1.25;            // Minimum ATR multiplier for breakout validation
input double   ATR_Mult_Max = 3.0;             // Maximum ATR multiplier
input bool     UseBBFilter = true;             // Enable Bollinger Bands filter
input int      BBPeriod = 20;                  // Bollinger Bands period
input double   BBDeviation = 2.0;              // Bollinger Bands standard deviation
input double   Min_Width_Pips = 30;            // Minimum BB width (pips)
input bool     UseADXFilter = true;            // Enable ADX filter
input int      ADXPeriod = 14;                 // ADX period
input double   MinADX = 20;                    // Minimum ADX value
input bool     UseRSIFilter = true;            // Enable RSI filter
input int      RSIPeriod = 14;                 // RSI period
input double   RSI_Overbought = 70;            // Overbought level
input double   RSI_Oversold = 30;              // Oversold level
input bool     UseVolumeFilter = true;         // Enable volume filter
input int      VolumeSMAPeriod = 20;           // Volume SMA period
input double   VolumeThreshold = 1.5;          // Volume threshold multiplier

// Trading parameters
input double   LotSize = 0.1;                  // Fixed lot size (use 0 for auto calculation)
input double   RiskPercent = 2.0;              // Risk percentage for auto lot calculation
input int      StopLossPips = 50;              // Stop loss in pips
input int      TakeProfitPips = 100;           // Take profit in pips
input int      Slippage = 3;                   // Maximum slippage in points
input int      MagicNumber = 12345;            // Expert advisor magic number
input string   TradeComment = "Breakout Logic"; // Trade comment

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
datetime lastBarTime = 0;
double rangeHigh = 0;
double rangeLow = 0;
double atrValue = 0;
double bbUpper = 0;
double bbLower = 0;
double bbWidth = 0;
double emaValue = 0;
double adxValue = 0;
double rsiValue = 0;
double volumeValue = 0;
double volumeSMA = 0;
bool newsBlocked = false;

//+------------------------------------------------------------------+
//| New bar detection                                                |
//+------------------------------------------------------------------+
bool IsNewBar(ENUM_TIMEFRAMES tf)
{
   datetime currentBar = iTime(_Symbol, tf, 0);
   if(lastBarTime != currentBar)
   {
      lastBarTime = currentBar;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Breakout entry detection                                         |
//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//| Retest check after breakout                                      |
//+------------------------------------------------------------------+
bool IsRetestLong(double level)
{
   double point   = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol     = 10 * point * 10; // 10 pips tolerance
   double lowBar  = iLow(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (lowBar <= level + tol && closeBar > level);
}

bool IsRetestShort(double level)
{
   double point    = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol      = 10 * point * 10; // 10 pips tolerance
   double highBar  = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (highBar >= level - tol && closeBar < level);
}

//+------------------------------------------------------------------+
//| Calculate lot size                                               |
//+------------------------------------------------------------------+
double CalcLotSize()
{
   if(LotSize > 0) return LotSize;
   
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   if(tickValue == 0 || point == 0) return 0.01;
   
   double riskAmount = accountBalance * RiskPercent / 100;
   double stopLossPoints = StopLossPips * 10;
   double lotSize = riskAmount / (stopLossPoints * point * tickValue);
   
   // Normalize lot size
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   lotSize = MathMax(lotSize, minLot);
   lotSize = MathMin(lotSize, maxLot);
   lotSize = MathRound(lotSize / lotStep) * lotStep;
   
   return lotSize;
}

//+------------------------------------------------------------------+
//| Update indicator values                                          |
//+------------------------------------------------------------------+
void UpdateIndicators()
{
   // Calculate range
   rangeHigh = iHigh(_Symbol, RangeTF, 1);
   rangeLow = iLow(_Symbol, RangeTF, 1);
   
   // Calculate ATR
   if(UseATRFilter)
   {
      atrValue = iATR(_Symbol, PERIOD_CURRENT, ATRPeriod, 0);
   }
   
   // Calculate Bollinger Bands
   if(UseBBFilter)
   {
      bbUpper = iBands(_Symbol, PERIOD_CURRENT, BBPeriod, BBDeviation, 0, PRICE_CLOSE, MODE_UPPER, 0);
      bbLower = iBands(_Symbol, PERIOD_CURRENT, BBPeriod, BBDeviation, 0, PRICE_CLOSE, MODE_LOWER, 0);
      bbWidth = (bbUpper - bbLower) / SymbolInfoDouble(_Symbol, SYMBOL_POINT) / 10;
   }
   
   // Calculate EMA for trend filter
   if(TrendFilterEMA > 0)
   {
      emaValue = iMA(_Symbol, PERIOD_H1, TrendFilterEMA, 0, MODE_EMA, PRICE_CLOSE, 0);
   }
   
   // Calculate ADX
   if(UseADXFilter)
   {
      adxValue = iADX(_Symbol, PERIOD_CURRENT, ADXPeriod, PRICE_CLOSE, MODE_MAIN, 0);
   }
   
   // Calculate RSI
   if(UseRSIFilter)
   {
      rsiValue = iRSI(_Symbol, PERIOD_CURRENT, RSIPeriod, PRICE_CLOSE, 0);
   }
   
   // Calculate volume
   if(UseVolumeFilter)
   {
      volumeValue = iVolume(_Symbol, PERIOD_CURRENT, 0);
      volumeSMA = iMAOnArray(volumeValue, 0, VolumeSMAPeriod, 0, MODE_SMA, 0);
   }
}

//+------------------------------------------------------------------+
//| Check news filter                                                |
//+------------------------------------------------------------------+
bool CheckNewsFilter()
{
   if(!UseNewsFilter) return true;
   
   // This is a simplified implementation
   // In real implementation, you would integrate with FFCal indicator
   // For now, we'll assume no news is present
   newsBlocked = false;
   
   // Placeholder for FFCal integration
   // bool hasHighImpactNews = FFCal_CheckNews(_Symbol, NewsMinutesBefore, NewsMinutesAfter, NewsImpactLevel);
   // newsBlocked = hasHighImpactNews;
   
   return !newsBlocked;
}

//+------------------------------------------------------------------+
//| Check indicator filters                                          |
//+------------------------------------------------------------------+
bool CheckIndicatorFilters(bool isLong)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   // ATR filter
   if(UseATRFilter)
   {
      double atrPips = atrValue / point / 10;
      if(atrPips < MinATRPips || atrPips > MaxATRPips) return false;
      
      // Check breakout magnitude vs ATR
      double breakoutDistance = 0;
      if(isLong)
         breakoutDistance = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - rangeHigh;
      else
         breakoutDistance = rangeLow - SymbolInfoDouble(_Symbol, SYMBOL_BID);
      
      double breakoutATRMultiplier = breakoutDistance / atrValue;
      if(breakoutATRMultiplier < ATR_Mult_Min || breakoutATRMultiplier > ATR_Mult_Max) return false;
   }
   
   // Bollinger Bands filter
   if(UseBBFilter)
   {
      if(bbWidth < Min_Width_Pips) return false;
   }
   
   // EMA trend filter
   if(TrendFilterEMA > 0)
   {
      double currentPrice = SymbolInfoDouble(_Symbol, isLong ? SYMBOL_ASK : SYMBOL_BID);
      if(isLong && currentPrice <= emaValue) return false;
      if(!isLong && currentPrice >= emaValue) return false;
   }
   
   // ADX filter
   if(UseADXFilter)
   {
      if(adxValue < MinADX) return false;
   }
   
   // RSI filter
   if(UseRSIFilter)
   {
      if(isLong && rsiValue >= RSI_Overbought) return false;
      if(!isLong && rsiValue <= RSI_Oversold) return false;
   }
   
   // Volume filter
   if(UseVolumeFilter && RequireVolumeConfirm)
   {
      if(volumeValue < volumeSMA * VolumeThreshold) return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check for breakout signals                                       |
//+------------------------------------------------------------------+
void CheckBreakoutSignals()
{
   // Check if we're on a new bar on execution timeframe
   if(!IsNewBar(ExecTF)) return;
   
   // Update all indicator values
   UpdateIndicators();
   
   // Check news filter
   if(!CheckNewsFilter()) return;
   
   // Check for long breakout
   if(AllowLong && IsBreakoutLong(rangeHigh))
   {
      // Check retest if required
      if(RequireRetest && !IsRetestLong(rangeHigh)) return;
      
      // Check indicator filters
      if(!CheckIndicatorFilters(true)) return;
      
      // Execute long trade
      ExecuteTrade(ORDER_TYPE_BUY);
   }
   
   // Check for short breakout
   if(AllowShort && IsBreakoutShort(rangeLow))
   {
      // Check retest if required
      if(RequireRetest && !IsRetestShort(rangeLow)) return;
      
      // Check indicator filters
      if(!CheckIndicatorFilters(false)) return;
      
      // Execute short trade
      ExecuteTrade(ORDER_TYPE_SELL);
   }
}

//+------------------------------------------------------------------+
//| Execute trade                                                    |
//+------------------------------------------------------------------+
void ExecuteTrade(ENUM_ORDER_TYPE orderType)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double price = 0;
   double sl = 0;
   double tp = 0;
   
   if(orderType == ORDER_TYPE_BUY)
   {
      price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      sl = price - StopLossPips * point * 10;
      tp = price + TakeProfitPips * point * 10;
   }
   else if(orderType == ORDER_TYPE_SELL)
   {
      price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      sl = price + StopLossPips * point * 10;
      tp = price - TakeProfitPips * point * 10;
   }
   
   double lotSize = CalcLotSize();
   
   MqlTradeRequest request;
   MqlTradeResult result;
   ZeroMemory(request);
   ZeroMemory(result);
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.type = orderType;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = Slippage;
   request.magic = MagicNumber;
   request.comment = TradeComment;
   request.type_filling = ORDER_FILLING_FOK;
   request.type_time = ORDER_TIME_GTC;
   
   if(!OrderSend(request, result))
   {
      Print("OrderSend failed: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Check and close positions before high impact news                |
//+------------------------------------------------------------------+
void CheckCloseBeforeNews()
{
   if(!CloseOnHighImpact || !newsBlocked) return;
   
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            MqlTradeRequest request;
            MqlTradeResult result;
            ZeroMemory(request);
            ZeroMemory(result);
            
            request.action = TRADE_ACTION_DEAL;
            request.symbol = PositionGetString(POSITION_SYMBOL);
            request.volume = PositionGetDouble(POSITION_VOLUME);
            request.position = PositionGetTicket(i);
            request.deviation = Slippage;
            
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
               request.type = ORDER_TYPE_SELL;
               request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            }
            else
            {
               request.type = ORDER_TYPE_BUY;
               request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            }
            
            if(!OrderSend(request, result))
            {
               Print("Close position failed: ", GetLastError());
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Main processing function                                         |
//+------------------------------------------------------------------+
void ProcessBreakoutLogic()
{
   // Check and close positions before news if needed
   CheckCloseBeforeNews();
   
   // Check for breakout signals
   CheckBreakoutSignals();
}

//+------------------------------------------------------------------+
