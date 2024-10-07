setwd("E:/UWM/628")
data <- read.csv("BodyFat_Cleaned.csv")
install.packages("car") #
library(car)
library(ggplot2) 



-----#VIF
# 查看VIF
model <- lm(BODYFAT ~ AGE + WEIGHT + HEIGHT  + ADIPOSITY   + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data)
# 计算VIF值
vif_values <- vif(model)
# 输出VIF值
print(vif_values)
vif_data <- data.frame(Variable = names(vif_values), VIF = vif_values)

# 绘制VIF值的柱状图
ggplot(vif_data, aes(x = reorder(Variable, VIF), y = VIF)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +  # 翻转坐标，使变量名水平显示
  theme_minimal() +
  labs(title = "VIF Values for Variables", x = "Variables", y = "VIF Value") +
  geom_text(aes(label = round(VIF, 2)), hjust = -0.3)  # 在柱状图上显示VIF值


----#劝自己回归
# 安装必要的包
install.packages("leaps")
# 加载leaps包
library(leaps)
# 进行全子集回归
# 假设你正在拟合的模型是 BODYFAT 作为因变量，其他变量作为自变量
best_subset <- regsubsets(BODYFAT ~ AGE + WEIGHT + HEIGHT  + NECK + CHEST + ABDOMEN + HIP + THIGH + KNEE + ANKLE + BICEPS + FOREARM + WRIST, data = data)
summary(best_subset)
# 获取每个变量组合的结果，包括 RSS，调整 R² 等信息
best_model <- summary(best_subset)
# 打印调整后的 R² 和选择的最优模型
best_model$adjr2
best_model$outmat


#选取8个值age + WEIGHT+ neck + abdomen + hip +thigh +forearm + wrist
modelfinal <- lm(BODYFAT ~ AGE + WEIGHT + NECK + ABDOMEN + HIP + THIGH + FOREARM + WRIST, data = data)
summary(modelfinal)



----#bootstrap健R2画图
# 加载必要的包
install.packages("boot")   # 如果没有安装boot包，可以先安装
library(boot)

# 定义Bootstrap函数，返回模型的R²
boot_r2 <- function(data, indices) {
  # Bootstrap抽样
  boot_sample <- data[indices, ]
  
  # 拟合线性回归模型
  model <- lm(BODYFAT ~ AGE + WEIGHT + NECK + ABDOMEN + HIP + THIGH + FOREARM + WRIST, data = boot_sample)
  
  # 返回R²值
  return(summary(model)$r.squared)
}

# 执行Bootstrap，重复1000次
set.seed(123)
bootstrap_results_r2 <- boot(data = data, statistic = boot_r2, R = 1000)

# 提取Bootstrap R²结果
r2_values <- bootstrap_results_r2$t

# 绘制Bootstrap R²分布图
hist(r2_values, breaks = 30, col = "lightgreen", border = "black", 
     main = "Bootstrap R-Squared Distribution", 
     xlab = "R-Squared", ylab = "Frequency")

# 添加网格线和图表样式
grid()


----#bootstrap准确性RMASE
  
  # 安装并加载必要的包
install.packages("boot")
library(boot)

# 自定义Bootstrap函数，返回预测的RMSE
boot_rmse <- function(data, indices) {
  # Bootstrap抽样
  boot_sample <- data[indices, ]
  
  # 拟合线性回归模型
  model <- lm(BODYFAT ~ AGE + WEIGHT + NECK + ABDOMEN + HIP + THIGH + FOREARM + WRIST, data = boot_sample)
  
  # 计算预测值
  predictions <- predict(model, newdata = boot_sample)
  
  # 计算RMSE（均方根误差）
  rmse <- sqrt(mean((boot_sample$BODYFAT - predictions)^2))
  
  return(rmse)
}

# 执行Bootstrap，重复1000次
set.seed(123)
bootstrap_results <- boot(data = data, statistic = boot_rmse, R = 1000)

# 查看Bootstrap的RMSE结果
print(bootstrap_results$t)

# 可视化Bootstrap结果
hist(bootstrap_results$t, breaks = 30, main = "Bootstrap RMSE Distribution", xlab = "RMSE", col = "lightblue")

