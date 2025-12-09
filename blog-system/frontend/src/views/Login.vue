<template>
  <div class="login-page">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>

    <div class="login-container">
      <div class="login-card">
        <div class="login-header">
          <div class="logo-icon">
            <el-icon size="48"><User /></el-icon>
          </div>
          <h1 class="login-title">欢迎回来</h1>
          <p class="login-subtitle">请输入您的账号密码</p>
        </div>



        <!-- 账号历史记录 -->
        <div v-if="accountHistory.length > 0" class="account-history">
          <div class="history-title">
            <el-icon><Clock /></el-icon>
            <span>选择已登录账号</span>
          </div>
          <div class="history-accounts">
            <div
              v-for="account in accountHistory"
              :key="account.id"
              class="history-account"
              @click="selectHistoryAccount(account)"
            >
              <div class="account-avatar">
                <el-icon><User /></el-icon>
              </div>
              <div class="account-info">
                <div class="account-username">{{ account.username }}</div>
                <div class="account-type">{{ account.role === 'admin' ? '管理员' : '普通用户' }}</div>
              </div>
              <div class="account-actions">
                <el-button
                  type="danger"
                  size="small"
                  text
                  @click.stop="removeAccount(account.id)"
                >
                  <el-icon><Delete /></el-icon>
                </el-button>
              </div>
            </div>
          </div>
          <el-divider>或手动输入</el-divider>
        </div>

        <el-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          class="login-form"
          @submit.prevent="handleLogin"
        >
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              placeholder="用户名"
              aria-label="用户名"
              size="large"
              :prefix-icon="User"
              clearable
            />
          </el-form-item>

          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="密码"
              aria-label="密码"
              size="large"
              :prefix-icon="Lock"
              show-password
              clearable
              @keyup.enter="handleLogin"
            />
          </el-form-item>

          <el-form-item>
            <div class="login-options">
              <el-checkbox v-model="loginForm.rememberMe"> 记住我 </el-checkbox>
            </div>
          </el-form-item>

          <el-form-item>
            <el-button
              type="primary"
              size="large"
              class="login-button"
              :loading="loading"
              @click="handleLogin"
            >
              {{ loading ? "登录中..." : "登录" }}
            </el-button>
          </el-form-item>
        </el-form>

        <div class="login-footer">
          <div class="footer-links">
            <span>还没有账号？</span>
            <el-link type="primary" @click="goToRegister">点击注册</el-link>
          </div>
          <el-button link @click="goHome">
            <el-icon><ArrowLeft /></el-icon>
            返回首页
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
import { useRouter } from "vue-router";
import { User, Lock, ArrowLeft, Clock, Delete } from "@element-plus/icons-vue";
import { ElMessage } from "element-plus";
import axios from "axios";

const router = useRouter();
const loginFormRef = ref();
const loading = ref(false);



// 账号历史记录
const accountHistory = ref([]);

// 表单数据
const loginForm = reactive({
  username: "",
  password: "",
  rememberMe: false,
});

// 加载账号历史记录
const loadAccountHistory = () => {
  const history = localStorage.getItem('accountHistory');
  if (history) {
    try {
      accountHistory.value = JSON.parse(history);
    } catch (error) {
      console.error('解析账号历史记录失败:', error);
      accountHistory.value = [];
    }
  }
};

// 保存账号到历史记录
const saveAccountToHistory = (username, role, token) => {
  const account = {
    id: Date.now().toString(),
    username,
    role,
    token,
    lastLoginTime: new Date().toISOString()
  };
  
  // 移除已存在的相同账号
  accountHistory.value = accountHistory.value.filter(
    acc => !(acc.username === username && acc.role === role)
  );
  
  // 添加到开头
  accountHistory.value.unshift(account);
  
  // 最多保存5个账号
  if (accountHistory.value.length > 5) {
    accountHistory.value = accountHistory.value.slice(0, 5);
  }
  
  // 保存到localStorage
  localStorage.setItem('accountHistory', JSON.stringify(accountHistory.value));
};

// 选择历史账号
const selectHistoryAccount = (account) => {
  // 直接使用保存的token登录
  if (account.role === 'admin') {
    localStorage.setItem('adminToken', account.token);
    localStorage.setItem('userRole', 'admin');
  } else {
    localStorage.setItem('userToken', account.token);
    localStorage.setItem('userRole', 'user');
  }
  
  localStorage.setItem('username', account.username);
  
  ElMessage.success(`欢迎回来，${account.username}！`);
  
  // 根据角色跳转到不同页面
  if (account.role === 'admin') {
    router.push('/admin');
  } else {
    router.push('/');
  }
};

// 移除账号
const removeAccount = (accountId) => {
  accountHistory.value = accountHistory.value.filter(acc => acc.id !== accountId);
  localStorage.setItem('accountHistory', JSON.stringify(accountHistory.value));
  ElMessage.success('账号已移除');
};

// 表单验证规则
const loginRules = {
  username: [
    { required: true, message: "请输入用户名", trigger: "blur" },
    {
      min: 3,
      max: 20,
      message: "用户名长度在 3 到 20 个字符",
      trigger: "blur",
    },
  ],
  password: [
    { required: true, message: "请输入密码", trigger: "blur" },
    { min: 6, max: 20, message: "密码长度在 6 到 20 个字符", trigger: "blur" },
  ],
};

// 处理登录
const handleLogin = async () => {
  if (!loginFormRef.value) return;

  try {
    const valid = await loginFormRef.value.validate();
    if (!valid) return;

    loading.value = true;

    try {
      // 统一使用用户登录接口
      const response = await axios.post("/api/auth/login", {
        username: loginForm.username,
        password: loginForm.password,
      });

      if (response.data.success) {
        // 保存token和用户信息
        const token = response.data.data.token;
        const userInfo = response.data.data.user || response.data.data;
        
        // 根据用户的角色信息自动设置权限
        const userRole = userInfo.isAdmin || userInfo.role === 'ADMIN' ? 'admin' : 'user';
        
        if (userRole === "admin") {
          localStorage.setItem("adminToken", token);
          localStorage.setItem("userRole", "admin");
        } else {
          localStorage.setItem("userToken", token);
          localStorage.setItem("userRole", "user");
        }

        localStorage.setItem(
          "username",
          userInfo.username || loginForm.username
        );

        // 保存账号到历史记录
        saveAccountToHistory(
          userInfo.username || loginForm.username,
          userRole,
          token
        );

        if (loginForm.rememberMe) {
          localStorage.setItem("rememberedUsername", loginForm.username);
        } else {
          localStorage.removeItem("rememberedUsername");
        }

        ElMessage.success("登录成功");

        // 根据角色跳转到不同页面
        if (userRole === "admin") {
          router.push("/admin");
        } else {
          router.push("/");
        }
      } else {
        ElMessage.error(response.data.message || "登录失败");
      }
    } catch (error) {
      console.error("登录请求失败:", error);

      // 模拟登录验证
      let loginSuccess = false;
      let userRole = 'user'; // 默认为普通用户

      if (
        loginForm.username === "admin" &&
        loginForm.password === "admin123"
      ) {
        // 管理员登录
        userRole = 'admin';
        const mockToken = "mock-admin-token-" + Date.now();
        localStorage.setItem("adminToken", mockToken);
        localStorage.setItem("userRole", "admin");
        localStorage.setItem("username", "admin");
        
        // 保存账号到历史记录
        saveAccountToHistory("admin", "admin", mockToken);
        
        loginSuccess = true;
        router.push("/admin");
      } else if (
        loginForm.username === "user" &&
        loginForm.password === "user123"
      ) {
        // 普通用户登录
        userRole = 'user';
        const mockToken = "mock-user-token-" + Date.now();
        localStorage.setItem("userToken", mockToken);
        localStorage.setItem("userRole", "user");
        localStorage.setItem("username", "user");
        
        // 保存账号到历史记录
        saveAccountToHistory("user", "user", mockToken);
        
        loginSuccess = true;
        router.push("/");
      }

      if (loginSuccess) {
        if (loginForm.rememberMe) {
          localStorage.setItem("rememberedUsername", loginForm.username);
        } else {
          localStorage.removeItem("rememberedUsername");
        }
        ElMessage.success("登录成功");
      } else {
        ElMessage.error("用户名或密码错误");
      }
    }
  } catch (error) {
    console.error("表单验证失败:", error);
  } finally {
    loading.value = false;
  }
};

// 返回首页
const goHome = () => {
  router.push("/");
};

// 跳转到注册页面
const goToRegister = () => {
  router.push("/register");
};

// 组件挂载时检查是否有记住的用户名
onMounted(() => {
  // 加载账号历史记录
  loadAccountHistory();
  
  const rememberedUsername = localStorage.getItem("rememberedUsername");
  if (rememberedUsername) {
    loginForm.username = rememberedUsername;
    loginForm.rememberMe = true;
  }

  // 如果已经登录，根据角色跳转到对应页面
  const adminToken = localStorage.getItem("adminToken");
  const userToken = localStorage.getItem("userToken");
  const userRole = localStorage.getItem("userRole");

  if (adminToken && userRole === "admin") {
    router.push("/admin");
  } else if (userToken && userRole === "user") {
    router.push("/dashboard");
  }
});
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  position: relative;
  overflow: hidden;
}

/* 背景装饰 */
.bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  animation: float 6s ease-in-out infinite;
}

.circle-1 {
  width: 200px;
  height: 200px;
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.circle-2 {
  width: 150px;
  height: 150px;
  top: 60%;
  right: 10%;
  animation-delay: 2s;
}

.circle-3 {
  width: 100px;
  height: 100px;
  bottom: 20%;
  left: 20%;
  animation-delay: 4s;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0px) rotate(0deg);
    opacity: 0.7;
  }
  50% {
    transform: translateY(-20px) rotate(180deg);
    opacity: 0.3;
  }
}

.login-container {
  width: 100%;
  max-width: 420px;
  position: relative;
  z-index: 2;
}

.login-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20px;
  padding: 2.5rem;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1), 0 0 0 1px rgba(255, 255, 255, 0.2);
  -webkit-backdrop-filter: blur(20px);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
}

.login-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
}

.login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.logo-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
  }
  50% {
    box-shadow: 0 10px 30px rgba(102, 126, 234, 0.5);
  }
  100% {
    box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
  }
}

.login-title {
  font-size: 2rem;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0 0 0.5rem 0;
}

.login-subtitle {
  color: #666;
  margin: 0;
  font-size: 1rem;
  font-weight: 400;
}



/* 账号历史记录样式 */
.account-history {
  margin-bottom: 1.5rem;
  padding: 1rem;
  background: rgba(102, 126, 234, 0.05);
  border-radius: 12px;
  border: 1px solid rgba(102, 126, 234, 0.1);
}

.history-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: #667eea;
}

.history-accounts {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.history-account {
  display: flex;
  align-items: center;
  padding: 0.75rem;
  background: white;
  border-radius: 8px;
  border: 1px solid rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
}

.history-account:hover {
  border-color: #667eea;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
  transform: translateY(-1px);
}

.account-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  margin-right: 0.75rem;
}

.account-info {
  flex: 1;
}

.account-username {
  font-weight: 600;
  color: #333;
  margin-bottom: 0.25rem;
}

.account-type {
  font-size: 0.8rem;
  color: #666;
}

.account-actions {
  opacity: 0;
  transition: opacity 0.3s ease;
}

.history-account:hover .account-actions {
  opacity: 1;
}

.login-form {
  margin-bottom: 1.5rem;
}

.login-options {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
}

.login-button {
  width: 100%;
  height: 48px;
  font-size: 1.1rem;
  font-weight: 600;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 12px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
}

.login-button:active {
  transform: translateY(0);
}

.login-button::before {
  content: "";
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.2),
    transparent
  );
  transition: left 0.5s;
}

.login-button:hover::before {
  left: 100%;
}

.login-footer {
  text-align: center;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}

.footer-links {
  margin-bottom: 1rem;
  color: #666;
}

.footer-links span {
  margin-right: 0.5rem;
}

.login-footer .el-button {
  color: #667eea;
  transition: all 0.3s ease;
}

.login-footer .el-button:hover {
  color: #764ba2;
  transform: translateX(-5px);
}

/* 输入框样式美化 */
:deep(.el-form-item) {
  margin-bottom: 1.5rem;
}

:deep(.el-input__wrapper) {
  border-radius: 12px;
  border: 2px solid #e8ecf0;
  transition: all 0.3s ease;
  background: #f8f9fa;
  box-shadow: none;
}

:deep(.el-input__wrapper:hover) {
  border-color: #667eea;
  background: white;
}

:deep(.el-input__wrapper.is-focus) {
  border-color: #667eea;
  background: white;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

:deep(.el-input__inner) {
  font-size: 1rem;
  padding: 12px 16px;
  color: #333;
}

:deep(.el-input__inner::placeholder) {
  color: #999;
  font-weight: 400;
}

:deep(.el-checkbox) {
  color: #666;
  font-weight: 500;
}

:deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
  background-color: #667eea;
  border-color: #667eea;
}

:deep(.el-checkbox__input.is-checked + .el-checkbox__label) {
  color: #667eea;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-page {
    padding: 0.5rem;
  }

  .login-card {
    padding: 2rem 1.5rem;
    border-radius: 16px;
  }

  .login-title {
    font-size: 1.6rem;
  }

  .logo-icon {
    width: 60px;
    height: 60px;
  }

  .circle-1,
  .circle-2,
  .circle-3 {
    display: none;
  }
}

@media (max-width: 480px) {
  .login-card {
    padding: 1.5rem 1rem;
  }

  .login-title {
    font-size: 1.4rem;
  }

  .login-button {
    height: 44px;
    font-size: 1rem;
  }
}

/* 动画效果 */
.login-card {
  animation: slideIn 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(40px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* 加载状态 */
:deep(.el-button.is-loading) {
  pointer-events: none;
}

:deep(.el-loading-spinner) {
  color: white;
}
</style>
