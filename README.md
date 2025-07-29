# VaR-Historical-vs-MonteCarlo

A comparison is performed between Historical and Monte Carlo VaR approaches for INFY.NS at the 95% and 99% confidence levels, using:
- Historical returns
- Monte Carlo simulation with best-fitting distribution (Student's t)

### Tools Used:
`quantmod` – for fetching stock prices  
- `PerformanceAnalytics` – to calculate log returns  
- `fitdistrplus` – to fit Normal and Logistic distributions  
- `MASS` – to fit Student’s t-distribution  
- `tseries` – for ADF test of stationarity  

🧠 Conclusion
Monte Carlo simulation with a fitted Student’s t-distribution provides a more flexible and accurate estimate of tail risk than the historical method.
It is particularly useful in modeling assets with non-normal or heavy-tailed return distributions.

📌 Author
Komal Limbachiya
M.Sc. Financial Mathematics
The Maharaja Sayajirao University of Baroda
