import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import BlogDetail from '../views/BlogDetail.vue'
import Admin from '../views/Admin.vue'
import UserDashboard from '../views/UserDashboard.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import Search from '../views/Search.vue'
import Articles from '../views/Articles.vue'
import Publish from '../views/Publish.vue'

// 路由配置
const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/blog/:id',
    name: 'BlogDetail',
    component: () => import('../views/BlogDetail.vue')
  },
  {
    path: '/admin',
    component: () => import('../views/Admin.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'Admin',
        redirect: { name: 'AdminBlogs' }
      },
      {
        path: 'blogs',
        name: 'AdminBlogs',
        component: () => import('../views/Admin.vue'),
        meta: { tab: 'blogs' }
      },
      {
        path: 'categories',
        name: 'AdminCategories',
        component: () => import('../views/Admin.vue'),
        meta: { tab: 'categories' }
      },
      {
        path: 'tags',
        name: 'AdminTags',
        component: () => import('../views/Admin.vue'),
        meta: { tab: 'tags' }
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue')
  },
  {
    path: '/dashboard',
    name: 'UserDashboard',
    component: () => import('../views/UserDashboard.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/search',
    name: 'Search',
    component: () => import('../views/Search.vue')
  },
  {
    path: '/articles',
    name: 'Articles',
    component: () => import('../views/Articles.vue')
  },
  {
    path: '/publish',
    name: 'Publish',
    component: () => import('../views/Publish.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/announcements',
    name: 'Announcements',
    component: () => import('../views/Announcements.vue')
  },
  {
    path: '/announcements/:id',
    name: 'AnnouncementDetail',
    component: () => import('../views/AnnouncementDetail.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const userToken = localStorage.getItem('userToken')
  const adminToken = localStorage.getItem('adminToken')
  const userRole = localStorage.getItem('userRole') // 'user' 或 'admin'
  const isAuthenticated = !!(userToken || adminToken)
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
  } else if (to.meta.requiresAdmin && userRole !== 'admin') {
    // 如果需要管理员权限但用户不是管理员，跳转到用户后台或登录页
    if (userToken && userRole === 'user') {
      next('/dashboard')
    } else {
      next('/login')
    }
  } else {
    next()
  }
})

export default router