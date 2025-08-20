export const SITE = {
  website: "https://chlingyu.github.io/blog/", // 您的GitHub Pages域名
  author: "chlingyu", // 您的姓名
  profile: "https://github.com/chlingyu", // 您的GitHub个人页面
  desc: "分享技术与生活的个人博客", // 博客描述
  title: "chlingyu的博客", // 博客标题
  ogImage: "astropaper-og.jpg",
  lightAndDarkMode: true,
  postPerIndex: 4,
  postPerPage: 4,
  scheduledPostMargin: 15 * 60 * 1000, // 15 minutes
  showArchives: true,
  showBackButton: true, // show back button in post detail
  editPost: {
    enabled: true,
    text: "编辑此页",
    url: "https://github.com/chlingyu/blog/edit/main/", // 编辑页面链接
  },
  dynamicOgImage: true,
  dir: "ltr", // "rtl" | "auto"
  lang: "zh-cn", // 设置为中文
  timezone: "Asia/Shanghai", // 设置为中国时区
} as const;
