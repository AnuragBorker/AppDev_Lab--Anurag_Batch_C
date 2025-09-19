package com.example.counter_app
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
class MainActivity : AppCompatActivity() {
    private var count = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        count = savedInstanceState?.getInt("count") ?: 0

        val tv = findViewById<TextView>(R.id.tvCount)
        val btnPlus = findViewById<Button>(R.id.btnPlus)
        val btnMinus = findViewById<Button>(R.id.btnMinus)
        val btnReset = findViewById<Button>(R.id.btnReset)

        fun render() { tv.text = count.toString() }

        btnPlus.setOnClickListener {
            count++
            render()
        }

        btnMinus.setOnClickListener {
            if (count > 0) count--
            render()
        }

        btnReset.setOnClickListener {
            count = 0
            render()
        }

        render()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt("count", count)
    }
}

