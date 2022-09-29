const URL = process.env.REACT_APP_API_URL || "http://localhost:4000";
const DEFAULT_HEADERS = {
  "Content-Type": "application/json",
};

const METHODS = {
  get: "get",
  post: "post",
};

const ROUTES = {
  create: "/api/v1/exam",
  get: "/api/v1/exam/:code",
  answer: "/api/v1/exam/:code/answer",
  income: "/api/v1/exam/:code/income",
  expenses: "/api/v1/exam/:code/expenses",
  calculate: "/api/v1/exam/:code/calculate",
};

function formatUrl(url, params) {
  return Object
    .keys(params)
    .reduce(
      (acc, key) => acc.replaceAll(`:${key}`, params[key]),
      url
    )
}

async function request({method, path, body, headers}) {
  const response = await fetch(URL + path, {
    method,
    body: JSON.stringify(body),
    headers: Object.assign(DEFAULT_HEADERS, headers),
  });
  body = await response.json();
  const {status, url, ok} = response;
  return {body, status, url, ok};
}

async function create() {
  return await request({method: METHODS.post, path: ROUTES.create});
}

async function get(code) {
  const path = formatUrl(ROUTES.get, {code});
  return await request({method: METHODS.get, path});
}

async function answer(code, answer) {
  const path = formatUrl(ROUTES.answer, {code});
  return await request({method: METHODS.post, path, body: {answer}});
}

async function income(code, income) {
  const path = formatUrl(ROUTES.income, {code});
  return await request({method: METHODS.post, path, body: {amount: income}});
}

async function expenses(code, expenses) {
  const path = formatUrl(ROUTES.expenses, {code});
  return await request({method: METHODS.post, path, body: {amount: expenses}});
}

async function calculate(code) {
  const path = formatUrl(ROUTES.calculate, {code});
  return await request({method: METHODS.post, path});
}

const api = {
  create,
  get,
  answer,
  income,
  expenses,
  calculate,
};

export default api;
