module ApplicationHelper
  def default_meta_tags
    {
      site: 'PATEN（パテン）',
      title: '',
      reverse: true,
      charset: 'utf-8',
      description: 'PATEN（パテン）は、Twitterで発信したいけど、何を発信すればいいか分からない人などを対象に質問を投げかけているサイトです。',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: 'PATEN（パテン）',
        title: 'PATEN（パテン）',
        description: 'PATEN（パテン）は、Twitterで発信したいけど、何を発信すればいいか分からない人などを対象に質問を投げかけているサイトです。',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@Nandeda_com',
      }
    }
  end
end
