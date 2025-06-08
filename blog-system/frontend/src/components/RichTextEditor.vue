<template>
  <div class="rich-text-editor">
    <div class="editor-toolbar">
      <!-- 编辑模式切换 -->
      <div class="mode-switch">
        <el-radio-group v-model="editorMode" size="small" @change="handleModeChange">
          <el-radio-button value="rich">富文本</el-radio-button>
          <el-radio-button value="markdown">Markdown</el-radio-button>
        </el-radio-group>
      </div>
      
      <!-- 工具栏按钮 -->
      <div class="toolbar-actions">
        <el-upload
          action="/api/upload/article-image"
          :show-file-list="false"
          :on-success="handleImageSuccess"
          :before-upload="beforeImageUpload"
          :headers="uploadHeaders"
          accept="image/*"
          class="image-upload-btn"
        >
          <el-button size="small" type="primary" plain>
            <el-icon><Plus /></el-icon>
            插入图片
          </el-button>
        </el-upload>
        
        <!-- Markdown模式下的预览按钮 -->
        <el-button 
          v-if="editorMode === 'markdown'" 
          size="small" 
          @click="togglePreview"
          :type="showPreview ? 'primary' : 'default'"
        >
          <el-icon><View /></el-icon>
          {{ showPreview ? '隐藏预览' : '预览' }}
        </el-button>
      </div>
    </div>
    
    <!-- 富文本编辑器 -->
    <QuillEditor
      v-if="editorMode === 'rich'"
      ref="quillEditor"
      v-model:content="content"
      :options="editorOptions"
      content-type="html"
      @update:content="handleContentChange"
      class="quill-editor"
    />
    
    <!-- Markdown编辑器 -->
    <div v-else class="markdown-editor-container">
      <div class="markdown-editor-wrapper" :class="{ 'split-view': showPreview }">
        <!-- Markdown输入区 -->
        <div class="markdown-input">
          <el-input
            v-model="markdownContent"
            type="textarea"
            :rows="20"
            :placeholder="placeholderText"
            @input="handleMarkdownChange"
            class="markdown-textarea"
          />
        </div>
        
        <!-- Markdown预览区 -->
        <div v-if="showPreview" class="markdown-preview">
          <div class="preview-header">
            <span>预览</span>
          </div>
          <div class="preview-content" v-html="markdownHtml"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, nextTick, computed } from 'vue'
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css'
import { ElMessage } from 'element-plus'
import { Plus, View } from '@element-plus/icons-vue'
import MarkdownIt from 'markdown-it'
import TurndownService from 'turndown'
import hljs from 'highlight.js'
import 'highlight.js/styles/github.css'

// Props
const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  placeholder: {
    type: String,
    default: '开始写作吧...'
  },
  height: {
    type: String,
    default: '400px'
  }
})

// Emits
const emit = defineEmits(['update:modelValue', 'image-uploaded'])

// 响应式数据
const content = ref(props.modelValue)
const quillEditor = ref(null)
const editorMode = ref('rich') // 'rich' | 'markdown'
const markdownContent = ref('')
const showPreview = ref(false)

// Markdown解析器配置
const md = new MarkdownIt({
  html: true,
  linkify: true,
  typographer: true,
  breaks: true,
  highlight: function (str, lang) {
    if (lang && hljs.getLanguage(lang)) {
      try {
        const result = hljs.highlight(str, { language: lang, ignoreIllegals: true })
        return `<pre class="hljs"><code class="hljs language-${lang}">${result.value}</code></pre>`
      } catch (__) {}
    }
    return `<pre class="hljs"><code class="hljs">${md.utils.escapeHtml(str)}</code></pre>`
  }
})

// HTML转Markdown服务
const turndownService = new TurndownService({
  headingStyle: 'atx',
  codeBlockStyle: 'fenced'
})

// 上传请求头
const uploadHeaders = ref({
  'Authorization': `Bearer ${localStorage.getItem('userToken') || localStorage.getItem('adminToken')}`
})

// Quill编辑器配置
const editorOptions = ref({
  theme: 'snow',
  placeholder: props.placeholder,
  modules: {
    toolbar: {
      container: [
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
        [{ 'font': [] }],
        [{ 'size': ['small', false, 'large', 'huge'] }],
        ['bold', 'italic', 'underline', 'strike'],
        [{ 'color': [] }, { 'background': [] }],
        [{ 'script': 'sub' }, { 'script': 'super' }],
        [{ 'list': 'ordered' }, { 'list': 'bullet' }],
        [{ 'indent': '-1' }, { 'indent': '+1' }],
        [{ 'direction': 'rtl' }],
        [{ 'align': [] }],
        ['link', 'image', 'video', 'formula'],
        ['code-block'],
        ['clean']
      ],
      handlers: {
        image: handleImageInsert
      }
    },
    history: {
      delay: 1000,
      maxStack: 50,
      userOnly: false
    }
  }
})

// Markdown预览HTML
const markdownHtml = computed(() => {
  return md.render(markdownContent.value)
})

// 占位符文本
const placeholderText = computed(() => {
  // Markdown模式下使用专门的代码高亮提示
  if (editorMode.value === 'markdown') {
    return `开始用Markdown写作吧...

💡 代码高亮使用方法：
使用三个反引号 \`\`\` 包围代码，并在开头指定语言名称

示例：
\`\`\`javascript
function hello() {
  console.log("Hello World!");
}
\`\`\`

\`\`\`python
def hello():
    print("Hello World!")
\`\`\`

\`\`\`java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
\`\`\`

支持的语言：javascript, python, java, html, css, sql, json, xml 等

其他语法：
# 标题
**粗体** *斜体*
- 列表项
[链接文字](网址)
![图片描述](图片链接)`
  }
  // 富文本模式下使用传入的placeholder
  return props.placeholder || '开始写作吧...'
})

// 监听内容变化
watch(() => props.modelValue, (newValue) => {
  if (newValue !== content.value) {
    content.value = newValue
    // 如果当前是Markdown模式，转换HTML为Markdown
    if (editorMode.value === 'markdown' && newValue) {
      markdownContent.value = turndownService.turndown(newValue)
    }
  }
})

// 处理内容变化
const handleContentChange = (newContent) => {
  content.value = newContent
  emit('update:modelValue', newContent)
}

// 处理Markdown内容变化
const handleMarkdownChange = () => {
  // 将Markdown转换为HTML并更新content
  const htmlContent = md.render(markdownContent.value)
  content.value = htmlContent
  emit('update:modelValue', htmlContent)
}

// 切换编辑模式
const handleModeChange = (mode) => {
  if (mode === 'markdown') {
    // 切换到Markdown模式，将HTML转换为Markdown
    if (content.value) {
      markdownContent.value = turndownService.turndown(content.value)
    }
    showPreview.value = false
  } else {
    // 切换到富文本模式，将Markdown转换为HTML
    if (markdownContent.value) {
      const htmlContent = md.render(markdownContent.value)
      content.value = htmlContent
      emit('update:modelValue', htmlContent)
    }
  }
}

// 切换预览
const togglePreview = () => {
  showPreview.value = !showPreview.value
}

// 处理图片插入
function handleImageInsert() {
  // 触发文件选择
  const input = document.createElement('input')
  input.setAttribute('type', 'file')
  input.setAttribute('accept', 'image/*')
  input.click()
  
  input.onchange = () => {
    const file = input.files[0]
    if (file) {
      uploadImage(file)
    }
  }
}

// 上传图片
const uploadImage = async (file) => {
  if (!beforeImageUpload(file)) {
    return
  }
  
  const formData = new FormData()
  formData.append('file', file)
  
  try {
    const response = await fetch('/api/upload/article-image', {
      method: 'POST',
      headers: uploadHeaders.value,
      body: formData
    })
    
    const result = await response.json()
    if (result.success) {
      insertImageToEditor(result.data.url)
      emit('image-uploaded', result.data.url)
      ElMessage.success('图片上传成功')
    } else {
      ElMessage.error('图片上传失败：' + result.message)
    }
  } catch (error) {
    console.error('图片上传错误：', error)
    ElMessage.error('图片上传失败')
  }
}

// 插入图片到编辑器
const insertImageToEditor = (imageUrl) => {
  const quill = quillEditor.value.getQuill()
  const range = quill.getSelection()
  const index = range ? range.index : quill.getLength()
  quill.insertEmbed(index, 'image', imageUrl)
  quill.setSelection(index + 1)
}

// 图片上传成功处理
const handleImageSuccess = (response) => {
  if (response.success) {
    const imageUrl = response.data.url
    emit('image-uploaded', imageUrl)
    
    if (editorMode.value === 'markdown') {
      // Markdown模式：插入Markdown图片语法
      const imageMarkdown = `![图片](${imageUrl})`
      const textarea = document.querySelector('.markdown-textarea textarea')
      if (textarea) {
        const start = textarea.selectionStart
        const end = textarea.selectionEnd
        const text = markdownContent.value
        markdownContent.value = text.substring(0, start) + imageMarkdown + text.substring(end)
        
        // 更新光标位置
        nextTick(() => {
          textarea.focus()
          textarea.setSelectionRange(start + imageMarkdown.length, start + imageMarkdown.length)
        })
        
        // 触发内容变化
        handleMarkdownChange()
      }
    } else {
      // 富文本模式：在编辑器中插入图片
      insertImageToEditor(imageUrl)
    }
    
    ElMessage.success('图片上传成功')
  } else {
    ElMessage.error('图片上传失败：' + response.message)
  }
}

// 图片上传前验证
const beforeImageUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件！')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB！')
    return false
  }
  return true
}

// 获取编辑器实例
const getQuillInstance = () => {
  return quillEditor.value?.getQuill()
}

// 获取纯文本内容
const getTextContent = () => {
  const quill = getQuillInstance()
  return quill ? quill.getText() : ''
}

// 设置内容
const setContent = (newContent) => {
  content.value = newContent
}

// 清空内容
const clearContent = () => {
  content.value = ''
}

// 添加工具栏按钮提示
const addToolbarTooltips = () => {
  const toolbar = document.querySelector('.ql-toolbar')
  if (!toolbar) return
  
  // 工具栏按钮提示映射
  const tooltips = {
    '.ql-header[value="1"]': '标题 1',
    '.ql-header[value="2"]': '标题 2', 
    '.ql-header[value="3"]': '标题 3',
    '.ql-header[value="4"]': '标题 4',
    '.ql-header[value="5"]': '标题 5',
    '.ql-header[value="6"]': '标题 6',
    '.ql-header[value="false"]': '正文',
    '.ql-bold': '粗体',
    '.ql-italic': '斜体',
    '.ql-underline': '下划线',
    '.ql-strike': '删除线',
    '.ql-color': '文字颜色',
    '.ql-background': '背景颜色',
    '.ql-script[value="sub"]': '下标',
    '.ql-script[value="super"]': '上标',
    '.ql-list[value="ordered"]': '有序列表',
    '.ql-list[value="bullet"]': '无序列表',
    '.ql-indent[value="-1"]': '减少缩进',
    '.ql-indent[value="+1"]': '增加缩进',
    '.ql-direction[value="rtl"]': '从右到左',
    '.ql-align[value=""]': '左对齐',
    '.ql-align[value="center"]': '居中对齐',
    '.ql-align[value="right"]': '右对齐',
    '.ql-align[value="justify"]': '两端对齐',
    '.ql-link': '插入链接',
    '.ql-image': '插入图片',
    '.ql-video': '插入视频',
    '.ql-formula': '插入公式',
    '.ql-code-block': '代码块',
    '.ql-clean': '清除格式',
    '.ql-size[value="small"]': '小号字体',
    '.ql-size[value="large"]': '大号字体',
    '.ql-size[value="huge"]': '超大字体',
    '.ql-size[value="false"]': '正常字体'
  }
  
  // 为每个按钮添加提示
  Object.entries(tooltips).forEach(([selector, tooltip]) => {
    const button = toolbar.querySelector(selector)
    if (button) {
      button.setAttribute('title', tooltip)
      button.style.cursor = 'pointer'
    }
  })
  
  // 为下拉选择器添加提示
  const headerSelect = toolbar.querySelector('.ql-header .ql-picker-label')
  if (headerSelect) {
    headerSelect.setAttribute('title', '选择标题级别')
  }
  
  const fontSelect = toolbar.querySelector('.ql-font .ql-picker-label')
  if (fontSelect) {
    fontSelect.setAttribute('title', '选择字体')
  }
  
  const sizeSelect = toolbar.querySelector('.ql-size .ql-picker-label')
  if (sizeSelect) {
    sizeSelect.setAttribute('title', '选择字体大小')
  }
  
  const colorSelect = toolbar.querySelector('.ql-color .ql-picker-label')
  if (colorSelect) {
    colorSelect.setAttribute('title', '选择文字颜色')
  }
  
  const backgroundSelect = toolbar.querySelector('.ql-background .ql-picker-label')
  if (backgroundSelect) {
    backgroundSelect.setAttribute('title', '选择背景颜色')
  }
  
  const alignSelect = toolbar.querySelector('.ql-align .ql-picker-label')
  if (alignSelect) {
    alignSelect.setAttribute('title', '选择对齐方式')
  }
}

// 组件挂载后添加提示
onMounted(() => {
  // 等待Quill编辑器完全初始化
  nextTick(() => {
    setTimeout(() => {
      addToolbarTooltips()
    }, 100)
  })
})

// 暴露方法给父组件
defineExpose({
  getQuillInstance,
  getTextContent,
  setContent,
  clearContent
})
</script>

<style scoped>
.rich-text-editor {
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  overflow: hidden;
}

.editor-toolbar {
  background: #f5f7fa;
  padding: 8px 12px;
  border-bottom: 1px solid #e4e7ed;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.mode-switch {
  flex-shrink: 0;
}

.toolbar-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.image-upload-btn {
  display: inline-block;
}

/* Markdown编辑器样式 */
.markdown-editor-container {
  height: 100%;
}

.markdown-editor-wrapper {
  display: flex;
  height: 500px;
}

.markdown-editor-wrapper.split-view .markdown-input {
  width: 50%;
  border-right: 1px solid #e4e7ed;
}

.markdown-input {
  width: 100%;
  height: 100%;
}

.markdown-textarea {
  height: 100%;
}

.markdown-textarea :deep(.el-textarea__inner) {
  height: 100% !important;
  resize: none;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  border: none;
  border-radius: 0;
}

.markdown-preview {
  width: 50%;
  height: 100%;
  background: #fff;
  display: flex;
  flex-direction: column;
}

.preview-header {
  background: #f8f9fa;
  padding: 8px 16px;
  border-bottom: 1px solid #e4e7ed;
  font-size: 14px;
  font-weight: 500;
  color: #606266;
}

.preview-content {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
  font-size: 14px;
  line-height: 1.6;
  color: #303133;
}

/* Markdown预览内容样式 */
.preview-content h1,
.preview-content h2,
.preview-content h3,
.preview-content h4,
.preview-content h5,
.preview-content h6 {
  margin: 1.5em 0 0.5em 0;
  font-weight: 600;
  line-height: 1.4;
}

.preview-content h1 {
  font-size: 2em;
  border-bottom: 2px solid #e4e7ed;
  padding-bottom: 0.3em;
}

.preview-content h2 {
  font-size: 1.5em;
  border-bottom: 1px solid #e4e7ed;
  padding-bottom: 0.3em;
}

.preview-content h3 {
  font-size: 1.25em;
}

.preview-content h4 {
  font-size: 1em;
}

.preview-content h5 {
  font-size: 0.875em;
}

.preview-content h6 {
  font-size: 0.85em;
  color: #6a737d;
}

.preview-content p {
  margin: 1em 0;
}

.preview-content blockquote {
  margin: 1em 0;
  padding: 0 1em;
  color: #6a737d;
  border-left: 4px solid #dfe2e5;
}

.preview-content ul,
.preview-content ol {
  margin: 1em 0;
  padding-left: 2em;
}

.preview-content li {
  margin: 0.25em 0;
}

.preview-content code {
  background: #f6f8fa;
  padding: 0.2em 0.4em;
  border-radius: 3px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 0.9em;
}

.preview-content pre {
  background: #f6f8fa;
  padding: 1em;
  border-radius: 6px;
  overflow-x: auto;
  margin: 1em 0;
}

.preview-content pre code {
  background: none;
  padding: 0;
}

/* 代码高亮样式 */
.preview-content .hljs {
  background: #f8f8f8 !important;
  border-radius: 6px;
  padding: 1em;
  overflow-x: auto;
  margin: 1em 0;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas', 'Courier New', monospace;
  font-size: 13px;
  line-height: 1.5;
}

.preview-content .hljs code {
  background: none !important;
  padding: 0;
  border-radius: 0;
  font-family: inherit;
  font-size: inherit;
}

/* 覆盖默认的pre和code样式 */
.preview-content pre.hljs {
  background: #f8f8f8 !important;
}

.preview-content pre.hljs code {
  background: transparent !important;
}

.preview-content table {
  border-collapse: collapse;
  margin: 1em 0;
  width: 100%;
}

.preview-content th,
.preview-content td {
  border: 1px solid #dfe2e5;
  padding: 6px 13px;
}

.preview-content th {
  background: #f6f8fa;
  font-weight: 600;
}

.preview-content img {
  max-width: 100%;
  height: auto;
  margin: 1em 0;
}

.preview-content a {
  color: #0366d6;
  text-decoration: none;
}

.preview-content a:hover {
  text-decoration: underline;
}

.preview-content hr {
  border: none;
  border-top: 1px solid #e1e4e8;
  margin: 2em 0;
}

:deep(.quill-editor) {
  background-color: white;
}

:deep(.ql-container) {
  min-height: v-bind(height);
  font-size: 14px;
  line-height: 1.6;
}

:deep(.ql-editor) {
  padding: 16px;
  min-height: v-bind(height);
}

:deep(.ql-toolbar) {
  border: none;
  border-bottom: 1px solid #e4e7ed;
  padding: 8px 12px;
}

:deep(.ql-snow .ql-tooltip) {
  z-index: 9999;
}

/* 自定义工具栏样式 */
:deep(.ql-toolbar .ql-formats) {
  margin-right: 8px;
}

:deep(.ql-toolbar button) {
  padding: 4px 6px;
  margin: 0 1px;
}

:deep(.ql-toolbar button:hover) {
  color: #409eff;
}

:deep(.ql-toolbar .ql-active) {
  color: #409eff;
}

/* 编辑器内容样式 */
:deep(.ql-editor h1) {
  font-size: 2em;
  font-weight: bold;
  margin: 0.67em 0;
}

:deep(.ql-editor h2) {
  font-size: 1.5em;
  font-weight: bold;
  margin: 0.75em 0;
}

:deep(.ql-editor h3) {
  font-size: 1.17em;
  font-weight: bold;
  margin: 0.83em 0;
}

:deep(.ql-editor h4) {
  font-size: 1em;
  font-weight: bold;
  margin: 1.12em 0;
}

:deep(.ql-editor h5) {
  font-size: 0.83em;
  font-weight: bold;
  margin: 1.5em 0;
}

:deep(.ql-editor h6) {
  font-size: 0.75em;
  font-weight: bold;
  margin: 1.67em 0;
}

:deep(.ql-editor p) {
  margin: 1em 0;
}

:deep(.ql-editor blockquote) {
  border-left: 4px solid #ccc;
  margin: 1em 0;
  padding-left: 1em;
  color: #666;
}

:deep(.ql-editor code) {
  background-color: #f4f4f4;
  border: 1px solid #ddd;
  border-radius: 3px;
  padding: 2px 4px;
  font-family: 'Courier New', monospace;
}

:deep(.ql-editor pre) {
  background-color: #f4f4f4;
  border: 1px solid #ddd;
  border-radius: 3px;
  padding: 1em;
  overflow-x: auto;
  font-family: 'Courier New', monospace;
}

:deep(.ql-editor img) {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 1em auto;
}

:deep(.ql-editor ul, .ql-editor ol) {
  padding-left: 1.5em;
}

:deep(.ql-editor li) {
  margin: 0.5em 0;
}

:deep(.ql-editor a) {
  color: #409eff;
  text-decoration: none;
}

:deep(.ql-editor a:hover) {
  text-decoration: underline;
}

/* Placeholder样式 - 支持换行显示 */
:deep(.ql-editor.ql-blank::before) {
  white-space: pre-line;
  line-height: 1.6;
  color: #c0c4cc;
}
</style>