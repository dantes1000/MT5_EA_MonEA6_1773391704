#property strict
input int BreakoutType = 0; // 0=Range, 1=BollingerBands, 2=ATR
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
input double ADXThreshold = 20.0; // Seuil ADX minimum
input bool UseRSIFilter = false; // Activer le filtre RSI
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

// TrendFilter.mqh - Strict EMA200 H1 trend filter with multiple confirmations
// Version 1.0

// Input parameters
input bool AllowLong = true; // Allow long positions
input bool AllowShort = true; // Allow short positions
input bool RequireVolumeConfirm = true; // Require volume confirmation
input bool RequireRetest = false; // Wait for retest before entry
input ENUM_TIMEFRAMES RangeTF = PERIOD_D1; // Timeframe for range calculation
input int TrendFilterEMA = 200; // EMA period for trend filter (0=disabled)
input ENUM_TIMEFRAMES ExecTF = PERIOD_M15; // Timeframe for trade execution
input bool UseNewsFilter = true; // Enable economic news filter
input int NewsMinutesBefore = 60; // Minutes before news to suspend trading
input int NewsMinutesAfter = 30; // Minutes after news to resume trading
input int NewsImpactLevel = 3; // Minimum impact level: 1=low, 2=medium, 3=high
input bool CloseOnHighImpact = true; // Close positions before high impact news
input double ATRMultiplier = 1.0; // ATR multiplier for breakout confirmation
input double BBWidthMin = 0.5; // Minimum Bollinger Bands width
input double BBWidthMax = 2.0; // Maximum Bollinger Bands width
input int ADXPeriod = 14; // ADX period
input double ADXMin = 20.0; // Minimum ADX value
input int RSIPeriod = 14; // RSI period
input double RSIOverbought = 70.0; // Overbought level
input double RSIOversold = 30.0; // Oversold level
input int VolumeSMAPeriod = 20; // Volume SMA period
input double VolumeThreshold = 1.5; // Volume threshold multiplier
input double RetestTolerancePips = 5.0; // Retest tolerance in pips
input int SignalShift = 0; // Signal shift for indicators
input int TradingStartHour = 8; // London open hour (GMT)
input int TradingEndHour = 21; // Friday close hour (GMT)
input double LotSize = 0.01; // Fixed lot size

// Global variables
int emaHandle = INVALID_HANDLE;
int atrHandle = INVALID_HANDLE;
int bbHandle = INVALID_HANDLE;
int adxHandle = INVALID_HANDLE;
int rsiHandle = INVALID_HANDLE;
int volumeSMAHandle = INVALID_HANDLE;
datetime lastBarTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnInit()
{
   // Initialize indicator handles
   if(TrendFilterEMA > 0)
      emaHandle = iMA(_Symbol, PERIOD_H1, TrendFilterEMA, 0, MODE_EMA, PRICE_CLOSE);
   
   atrHandle = iATR(_Symbol, RangeTF, 14);
   bbHandle = iBands(_Symbol, RangeTF, 20, 0, 2.0, PRICE_CLOSE);
   adxHandle = iADX(_Symbol, RangeTF, ADXPeriod);
   rsiHandle = iRSI(_Symbol, RangeTF, RSIPeriod, PRICE_CLOSE);
   volumeSMAHandle = iMA(_Symbol, PERIOD_CURRENT, VolumeSMAPeriod, 0, MODE_SMA, VOLUME_TICK);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Release indicator handles
   if(emaHandle != INVALID_HANDLE) IndicatorRelease(emaHandle);
   if(atrHandle != INVALID_HANDLE) IndicatorRelease(atrHandle);
   if(bbHandle != INVALID_HANDLE) IndicatorRelease(bbHandle);
   if(adxHandle != INVALID_HANDLE) IndicatorRelease(adxHandle);
   if(rsiHandle != INVALID_HANDLE) IndicatorRelease(rsiHandle);
   if(volumeSMAHandle != INVALID_HANDLE) IndicatorRelease(volumeSMAHandle);
}

//+------------------------------------------------------------------+
//| New bar detection                                                |
//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//| Get indicator value                                              |
//+------------------------------------------------------------------+
double GetIndicatorValue(int handle, int buffer, int shift)
{
   double value[1];
   if(CopyBuffer(handle, buffer, shift, 1, value) == 1)
      return value[0];
   return 0.0;
}

//+------------------------------------------------------------------+
//| Breakout entry functions                                         |
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
   double tol     = RetestTolerancePips * point * 10;
   double lowBar  = iLow(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (lowBar <= level + tol && closeBar > level);
}

bool IsRetestShort(double level)
{
   double point    = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol      = RetestTolerancePips * point * 10;
   double highBar  = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (highBar >= level - tol && closeBar < level);
}

//+------------------------------------------------------------------+
//| Trend filter - Strict EMA200 H1                                  |
//+------------------------------------------------------------------+
bool IsTrendLong()
{
   if(emaHandle == INVALID_HANDLE || TrendFilterEMA == 0) return true;
   
   double emaValue = GetIndicatorValue(emaHandle, 0, 0);
   double closePrice = iClose(_Symbol, PERIOD_H1, 0);
   
   return closePrice > emaValue;
}

bool IsTrendShort()
{
   if(emaHandle == INVALID_HANDLE || TrendFilterEMA == 0) return true;
   
   double emaValue = GetIndicatorValue(emaHandle, 0, 0);
   double closePrice = iClose(_Symbol, PERIOD_H1, 0);
   
   return closePrice < emaValue;
}

//+------------------------------------------------------------------+
//| ATR volatility filter                                            |
//+------------------------------------------------------------------+
bool IsATRValidLong(double highLevel, double lowLevel)
{
   double atrValue = GetIndicatorValue(atrHandle, 0, 0);
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   
   return (currentPrice - lowLevel) > (atrValue * ATRMultiplier);
}

bool IsATRValidShort(double highLevel, double lowLevel)
{
   double atrValue = GetIndicatorValue(atrHandle, 0, 0);
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   return (highLevel - currentPrice) > (atrValue * ATRMultiplier);
}

//+------------------------------------------------------------------+
//| Bollinger Bands width filter                                     |
//+------------------------------------------------------------------+
bool IsBBWidthValid()
{
   double upperBand = GetIndicatorValue(bbHandle, 1, 0);
   double lowerBand = GetIndicatorValue(bbHandle, 2, 0);
   double middleBand = GetIndicatorValue(bbHandle, 0, 0);
   
   if(middleBand == 0) return false;
   
   double width = (upperBand - lowerBand) / middleBand;
   
   return (width >= BBWidthMin && width <= BBWidthMax);
}

//+------------------------------------------------------------------+
//| ADX trend strength filter                                        |
//+------------------------------------------------------------------+
bool IsADXValid()
{
   double adxValue = GetIndicatorValue(adxHandle, 0, 0);
   return adxValue >= ADXMin;
}

//+------------------------------------------------------------------+
//| RSI overbought/oversold filter                                   |
//+------------------------------------------------------------------+
bool IsRSIValidLong()
{
   double rsiValue = GetIndicatorValue(rsiHandle, 0, 0);
   return rsiValue < RSIOverbought;
}

bool IsRSIValidShort()
{
   double rsiValue = GetIndicatorValue(rsiHandle, 0, 0);
   return rsiValue > RSIOversold;
}

//+------------------------------------------------------------------+
//| Volume confirmation filter                                       |
//+------------------------------------------------------------------+
bool IsVolumeValid()
{
   if(!RequireVolumeConfirm) return true;
   
   double currentVolume = iVolume(_Symbol, PERIOD_CURRENT, 0);
   double volumeSMA = GetIndicatorValue(volumeSMAHandle, 0, 0);
   
   if(volumeSMA == 0) return false;
   
   return (currentVolume / volumeSMA) >= VolumeThreshold;
}

//+------------------------------------------------------------------+
//| Trading time filter                                              |
//+------------------------------------------------------------------+
bool IsTradingTime()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   
   // Check day of week (0=Sunday, 1=Monday, ..., 5=Friday, 6=Saturday)
   if(dt.day_of_week == 0 || dt.day_of_week == 6) return false;
   
   // Check trading hours (London session)
   if(dt.hour < TradingStartHour) return false;
   
   // Check Friday close time
   if(dt.day_of_week == 5 && dt.hour >= TradingEndHour) return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| News filter (simplified implementation)                          |
//+------------------------------------------------------------------+
bool IsNewsFilterValid()
{
   if(!UseNewsFilter) return true;
   
   // In a real implementation, you would connect to a news feed API
   // This is a simplified placeholder
   return true;
}

//+------------------------------------------------------------------+
//| Calculate lot size                                               |
//+------------------------------------------------------------------+
double CalcLotSize()
{
   // Using fixed lot size as specified in inputs
   return LotSize;
}

//+------------------------------------------------------------------+
//| Main filter function - Check all conditions for long entry       |
//+------------------------------------------------------------------+
bool CheckLongEntry(double highLevel, double lowLevel)
{
   if(!AllowLong) return false;
   if(!IsTradingTime()) return false;
   if(!IsNewsFilterValid()) return false;
   if(!IsTrendLong()) return false;
   if(!IsATRValidLong(highLevel, lowLevel)) return false;
   if(!IsBBWidthValid()) return false;
   if(!IsADXValid()) return false;
   if(!IsRSIValidLong()) return false;
   if(!IsVolumeValid()) return false;
   
   // Check breakout
   if(!IsBreakoutLong(highLevel)) return false;
   
   // Check retest if required
   if(RequireRetest && !IsRetestLong(highLevel)) return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Main filter function - Check all conditions for short entry      |
//+------------------------------------------------------------------+
bool CheckShortEntry(double highLevel, double lowLevel)
{
   if(!AllowShort) return false;
   if(!IsTradingTime()) return false;
   if(!IsNewsFilterValid()) return false;
   if(!IsTrendShort()) return false;
   if(!IsATRValidShort(highLevel, lowLevel)) return false;
   if(!IsBBWidthValid()) return false;
   if(!IsADXValid()) return false;
   if(!IsRSIValidShort()) return false;
   if(!IsVolumeValid()) return false;
   
   // Check breakout
   if(!IsBreakoutShort(lowLevel)) return false;
   
   // Check retest if required
   if(RequireRetest && !IsRetestShort(lowLevel)) return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Check if position should be closed before weekend                |
//+------------------------------------------------------------------+
bool ShouldCloseBeforeWeekend()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   
   // Check if it's Friday and approaching close time
   if(dt.day_of_week == 5 && dt.hour >= (TradingEndHour - 1))
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| Get range levels                                                 |
//+------------------------------------------------------------------+
void GetRangeLevels(double &highLevel, double &lowLevel)
{
   highLevel = iHigh(_Symbol, RangeTF, 1);
   lowLevel = iLow(_Symbol, RangeTF, 1);
}

//+------------------------------------------------------------------+
//| Example usage in OnTick function                                 |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check for new bar on execution timeframe
   if(!IsNewBar(ExecTF)) return;
   
   // Get range levels
   double highLevel, lowLevel;
   GetRangeLevels(highLevel, lowLevel);
   
   // Check for long entry
   if(CheckLongEntry(highLevel, lowLevel))
   {
      // Execute long trade
      double lotSize = CalcLotSize();
      // Add your trade execution logic here
   }
   
   // Check for short entry
   if(CheckShortEntry(highLevel, lowLevel))
   {
      // Execute short trade
      double lotSize = CalcLotSize();
      // Add your trade execution logic here
   }
   
   // Check if positions should be closed before weekend
   if(ShouldCloseBeforeWeekend())
   {
      // Close all positions
      // Add your position closing logic here
   }
}
