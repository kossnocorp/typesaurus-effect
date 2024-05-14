import { schema } from "typesaurus";

interface User {
  name: string;
  age: number;
}

interface Post {
  title: string;
  text: string;
}

const db = schema(($) => ({
  users: $.collection<User>(),
  posts: $.collection<Post>(),
}));

// TODO:
