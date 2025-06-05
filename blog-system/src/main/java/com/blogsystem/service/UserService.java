package com.blogsystem.service;

import com.blogsystem.entity.User;
import com.blogsystem.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;

    // 创建用户
    public User createUser(User user) {
        // 这里应该加密密码，简化处理
        return userRepository.save(user);
    }

    // 更新用户信息
    public User updateUser(User user) {
        return userRepository.save(user);
    }

    // 根据ID查找用户
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    // 根据用户名查找用户
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    // 根据邮箱查找用户
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // 用户登录验证
    public Optional<User> authenticate(String account, String password) {
        Optional<User> userOpt = userRepository.findByAccount(account);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // 这里应该验证加密后的密码，简化处理直接比较
            if (password.equals(user.getPassword())) {
                // 更新最后登录时间
                user.setLastLogin(LocalDateTime.now());
                userRepository.save(user);
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    // 检查账号是否存在
    public boolean existsByAccount(String account) {
        return userRepository.existsByAccount(account);
    }

    // 检查用户名是否存在
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    // 检查邮箱是否存在
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    // 删除用户
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    // 获取所有用户
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // 用户注册
    public User registerUser(String account, String username, String email, String password, String fullName) {
        // 检查账号、用户名和邮箱是否已存在
        if (existsByAccount(account)) {
            throw new RuntimeException("账号已存在");
        }
        if (existsByUsername(username)) {
            throw new RuntimeException("用户名已存在");
        }
        // 只有当email不为null时才检查邮箱是否已存在
        if (email != null && existsByEmail(email)) {
            throw new RuntimeException("邮箱已存在");
        }

        User user = new User();
        user.setAccount(account);
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password); // 实际应用中需要加密
        user.setFullName(fullName);
        user.setIsAdmin(false);

        return userRepository.save(user);
    }

    // 修改密码
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // 验证旧密码
            if (oldPassword.equals(user.getPassword())) {
                user.setPassword(newPassword); // 实际应用中需要加密
                userRepository.save(user);
                return true;
            }
        }
        return false;
    }

    // 设置管理员权限
    public User setAdminRole(Long userId, boolean isAdmin) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setIsAdmin(isAdmin);
            return userRepository.save(user);
        }
        return null;
    }
}