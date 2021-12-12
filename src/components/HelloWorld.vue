<template>
  <div class="hello">
    <h1>{{ msg1 }}</h1>


    <span v-if="failAttempts <=3 && failAttempts > 0"> You have entered the wrong password {{failAttempts}} times</span>
    <span v-if="failAttempts >3"> Your acccount is locked. Please reset it.</span>
    <form @submit.prevent="handleLogin">
      <div>
        <label> Username </label>
        <input type="username" v-model="username" />
      </div>
      <div>
        <label> Password </label>
        <input type="password" v-model="password" />
      </div>
      <button>Login</button>
    </form>

    <div v-if="isLock">
      <h3>Unlock user</h3>
      <ul>
        <button v-on:click="handleReset">reset</button>
      </ul>
    </div>
  </div>
  
</template>
<script>
import axios from "axios";

export default {
  name: "HelloWorld",
  props: {
    msg1: String,
  },
  data() {
    return {
      username: "",
      password: "",
      isLock: false,
      failAttempts:0
    };
  },
  methods: {
    handleLogin() {
      const url = "/login";
      axios
        .post(
          url,
          {
            username: this.username,
            password: this.password,
          },
        )
        .then((res) => {
          var failAttempts = JSON.parse(res.data).failAttempts;
          this.isLock = failAttempts >= 3;
          this.failAttempts = failAttempts;
          this.$router.push({path: '/hello'});

        })
        .catch((err) => {
          var failAttempts = JSON.parse(err.response.data).failAttempts;
          this.isLock = failAttempts >= 3;
          this.failAttempts = failAttempts;
        });
    },
    handleReset() {
      const url = "/unlock";
      axios
        .post(url)
        .then((res) => {
          
          var resp = res.data;
          this.isLock = resp != "Successful!";
          alert("User Successful reset!");
          this.failAttempts = 0;
        })
        .catch((res) => {
          console.log("error" + res);
        });
    },
    alert(resp) {
      this.$alert(resp);
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
span{
   color: #f30303;
}
</style>
