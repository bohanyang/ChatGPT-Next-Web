export async function POST(req: Request) {
  try {
    let apiKey = process.env.OPENAI_API_KEY;
    let apiHost = process.env.OPENAI_API_HOST || 'https://api.openai.com';

    const userApiKey = req.headers.get("token");
    if (userApiKey) {
      apiKey = userApiKey;
    }

    const res = await fetch(`${apiHost}/v1/chat/completions`, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      method: "POST",
      body: req.body,
    });

    return new Response(res.body);
  } catch (e) {
    console.error("[Chat] ", e);
    return new Response(JSON.stringify(e));
  }
}
