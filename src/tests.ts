import * as admin from "firebase-admin";
import { schema } from "typesaurus";
import { describe, it } from "vitest";

admin.initializeApp();

interface User {
  name: string;
  age: number;
}

const db = schema(($) => ({
  users: $.collection<User>(),
}));

describe("Effect", () => {
  it.todo("TODO");
});
